#!/bin/bash

# Requires sed.

# Show the commands.
set -x

# Exit if there is an error.
set -e

mkdir prep_src
cp decNumber-icu-368/* prep_src
cp cms370/* prep_src
rm prep_src/*.html
rm prep_src/*.pdf

pushd prep_src

# Rename all the source files to something CMS can handle.
mv decBasic.c       dnBasic.c
mv decCMS.h         dnCMS.h
mv decCommon.c      dnCommon.c
mv decContext.c     dnCtxt.c
mv decContext.h     dnCtxt.h
mv decDPD.h         dnDPD.h
mv decDouble.c      dnDouble.c
mv decDouble.h      dnDouble.h
mv decNumber.c      dnNumber.c
mv decNumber.h      dnNumber.h
mv decNumberLocal.h dnLocal.h
mv decPacked.c      dnPacked.c
mv decPacked.h      dnPacked.h
mv decQuad.c        dnQuad.c
mv decQuad.h        dnQuad.h
mv decShortNames.h  dnShnm.h
mv decSingle.c      dnSingle.c
mv decSingle.h      dnSingle.h
mv decimal128.c     dn128.c
mv decimal128.h     dn128.h
mv decimal32.c      dn32.c
mv decimal32.h      dn32.h
mv decimal64.c      dn64.c
mv decimal64.h      dn64.h

# Fix all the references to files we renamed above.
for FILE in *.c *.h ; do
    sed -i "$FILE"                           \
        -e "s@decBasic\.c@dnBasic\.c@"       \
        -e "s@decCMS\.h@dnCMS\.h@"           \
        -e "s@decCommon\.c@dnCommon\.c@"     \
        -e "s@decContext\.h@dnCtxt\.h@"      \
        -e "s@decDPD\.h@dnDPD\.h@"           \
        -e "s@decDouble\.h@dnDouble\.h@"     \
        -e "s@decNumber\.h@dnNumber\.h@"     \
        -e "s@decNumberLocal\.h@dnLocal\.h@" \
        -e "s@decPacked\.h@dnPacked\.h@"     \
        -e "s@decQuad\.h@dnQuad\.h@"         \
        -e "s@decShortNames\.h@dnShnm\.h@"   \
        -e "s@decSingle\.h@dnSingle\.h@"     \
        -e "s@decimal128\.h@dn128\.h@"       \
        -e "s@decimal32\.h@dn32\.h@"         \
        -e "s@decimal64\.h@dn64\.h@"
done

popd
