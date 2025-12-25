@SETLOCAL

@REM Requires sed.

MKDIR prep_src
COPY decNumber-icu-368\* prep_src
COPY cms370\* prep_src
DEL prep_src\*.html
DEL prep_src\*.pdf

PUSHD prep_src

@REM Rename all the source files to something CMS can handle.
RENAME decBasic.c       dnBasic.c
RENAME decCMS.h         dnCMS.h
RENAME decCommon.c      dnCommon.c
RENAME decContext.c     dnCtxt.c
RENAME decContext.h     dnCtxt.h
RENAME decDPD.h         dnDPD.h
RENAME decDouble.c      dnDouble.c
RENAME decDouble.h      dnDouble.h
RENAME decNumber.c      dnNumber.c
RENAME decNumber.h      dnNumber.h
RENAME decNumberLocal.h dnLocal.h
RENAME decPacked.c      dnPacked.c
RENAME decPacked.h      dnPacked.h
RENAME decQuad.c        dnQuad.c
RENAME decQuad.h        dnQuad.h
RENAME decShortNames.h  dnShnm.h
RENAME decSingle.c      dnSingle.c
RENAME decSingle.h      dnSingle.h
RENAME decimal128.c     dn128.c
RENAME decimal128.h     dn128.h
RENAME decimal32.c      dn32.c
RENAME decimal32.h      dn32.h
RENAME decimal64.c      dn64.c
RENAME decimal64.h      dn64.h

@REM Fix all the references to files we renamed above.
FOR %%F in (*.c *.h) ; DO sed -i "%%F"       ^
        -e "s@decBasic\.c@dnBasic\.c@"       ^
        -e "s@decCMS\.h@dnCMS\.h@"           ^
        -e "s@decCommon\.c@dnCommon\.c@"     ^
        -e "s@decContext\.h@dnCtxt\.h@"      ^
        -e "s@decDPD\.h@dnDPD\.h@"           ^
        -e "s@decDouble\.h@dnDouble\.h@"     ^
        -e "s@decNumber\.h@dnNumber\.h@"     ^
        -e "s@decNumberLocal\.h@dnLocal\.h@" ^
        -e "s@decPacked\.h@dnPacked\.h@"     ^
        -e "s@decQuad\.h@dnQuad\.h@"         ^
        -e "s@decShortNames\.h@dnShnm\.h@"   ^
        -e "s@decSingle\.h@dnSingle\.h@"     ^
        -e "s@decimal128\.h@dn128\.h@"       ^
        -e "s@decimal32\.h@dn32\.h@"         ^
        -e "s@decimal64\.h@dn64\.h@"

POPD