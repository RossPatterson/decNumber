#!/usr/bin/bash
# Make decNumber on CMS370

# Exit if there is an error
set -euo pipefail

# Show the commands
set -x

# Prepare the source code for CMS use in ./prep_src.
./cms370/prepare_source.sh
# mkdir src
# cp decNumber-icu-368/* src
# cp cms370/* src
# rm src/*.html
# rm src/*.pdf
#
# pushd src
#
# Rename all the source files to something CMS can handle.
# mv decBasic.c          dnBasic.c
# mv decCMS.h            dnCMS.h
# mv decCommon.c         dnCommon.c
# mv decContext.c        dnCtxt.c
# mv decContext.h        dnCtxt.h
# mv decDPD.h            dnDPD.h
# mv decDouble.c         dnDouble.c
# mv decDouble.h         dnDouble.h
# mv decNumber.c         dnNumber.c
# mv decNumber.h         dnNumber.h
# mv decNumberLocal.h    dnLocal.h
# mv decPacked.c         dnPacked.c
# mv decPacked.h         dnPacked.h
# mv decQuad.c           dnQuad.c
# mv decQuad.h           dnQuad.h
# mv decShortNames.h     dnShnm.h
# mv decSingle.c         dnSingle.c
# mv decSingle.h         dnSingle.h
# mv decimal128.c        dn128.c
# mv decimal128.h        dn128.h
# mv decimal32.c         dn32.c
# mv decimal32.h         dn32.h
# mv decimal64.c         dn64.c
# mv decimal64.h         dn64.h
#
# Fix all the references to files we renamed above.
# for FILE in *.c *.h ; do
    # sed -i "$FILE" \
        # -e s"@decBasic\.c@dnBasic\.c@" \
        # -e s"@decCMS\.h@dnCMS\.h@" \
        # -e s"@decCommon\.c@dnCommon\.c@" \
        # -e s"@decContext\.h@dnCtxt\.h@" \
        # -e s"@decDPD\.h@dnDPD\.h@" \
        # -e s"@decDouble\.h@dnDouble\.h@" \
        # -e s"@decNumber\.h@dnNumber\.h@" \
        # -e s"@decNumberLocal\.h@dnLocal\.h@" \
        # -e s"@decPacked\.h@dnPacked\.h@" \
        # -e s"@decQuad\.h@dnQuad\.h@" \
        # -e s"@decShortNames\.h@dnShnm\.h@" \
        # -e s"@decSingle\.h@dnSingle\.h@" \
        # -e s"@decimal128\.h@dn128\.h@" \
        # -e s"@decimal32\.h@dn32\.h@" \
        # -e s"@decimal64\.h@dn64\.h@"
# done
#
# popd

# IPL VM/370.
herccontrol "IPL 6A1" -w "USER DSC LOGOFF AS AUTOLOG1"
herccontrol "/CP START 00C" -w "RDR"
herccontrol "/CP START 00D CLASS A" -w "PUN"

# Logon CMSUSER.
herccontrol "/CP DISC" -w "^VM/370 Online"
herccontrol "/LOGON CMSUSER CMSUSER" -w "^VM Community Edition"
herccontrol "/" -w "^Ready;"
herccontrol "/PURGE RDR" -w "^Ready;"
herccontrol "/ACCESS 191 A (ERASE" -w "^Ready;"
herccontrol "/ACCESS 192 D (ERASE" -w "^Ready;"

# Upload source code and tools.
yata -c -d prep_src -f archive.yata
MARK=`herccontrol -m`
echo "USERID CMSUSER NAME ARCHIVE YATA" > tmp
echo ":READ ARCHIVE YATA" >> tmp
cat archive.yata >> tmp
netcat -q 0 localhost 3505 < tmp
herccontrol -w "HHCRD012I" -f "$MARK"
herccontrol "/" -w "RDR FILE"
herccontrol "/YATA -x -f READER -d D" -w "^Ready;"
herccontrol "/ACCESS 192 D/A" -w "^Ready;"
rm archive.yata tmp
rm -rf prep_src

# Make source package.
herccontrol "devinit 00d io/decnums.vmarc" -w "^HHCPN098I"
herccontrol "/VMARC PACK * * D DECNUMS VMARC A (APPEND NOTRACE" -w "^Ready;"
herccontrol "/PUNCH DECNUMS VMARC A (NOHEADER" -w "^Ready;"
herccontrol "devinit 00d dummy" -w "^HHCPN098I"
sleep 5    # Because "devinit" is timing-related :-(
# Remove the trailing lace card:
truncate -s-80 decnums.vmarc
herccontrol "/ERASE DECNUMS VMARC A" -w "^Ready;"

# Build.
herccontrol "/BUILD" -w "^Ready;" -t 240

# Make binary package
herccontrol "devinit 00d io/decnumb.vmarc" -w "^HHCPN098I"
herccontrol "/VMARC PACK DECNUM TXTLIB A DECNUMB VMARC A (APPEND NOTRACE" -w "^Ready;"
herccontrol "/VMARC PACK * H D DECNUMB VMARC A (APPEND NOTRACE" -w "^Ready;"
herccontrol "/PUNCH DECNUMB VMARC A (NOHEADER" -w "^Ready;"
herccontrol "devinit 00d dummy" -w "^HHCPN098I"
sleep 5    # Because "devinit" is timing-related :-(
# Remove the trailing lace card:
truncate -s-80 decnumb.vmarc

# Build and run tests
# Note: These next two accept RC > 0.  We'll remove that when the tests are cleaned up.
herccontrol "/MKTEST" -w "^Ready;"
herccontrol "/RUNTEST" -w "^Ready;"

# Logoff.
herccontrol "/LOGOFF" -w "^VM/370 Online"

# Shutdown.
herccontrol "/LOGON OPERATOR OPERATOR" -w "RECONNECTED AT"
herccontrol "/SHUTDOWN" -w "^HHCCP011I"
