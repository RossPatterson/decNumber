@SETLOCAL

@REM Requires "vma" from https://www.homerow.net/zvm/vma/.

DEL DECNUMS.VMARC 2>NUL:

PUSHD prep_src
FOR %%F IN (*) DO  vma -a -t ..\DECNUMS.VMARC %%F
POPD

@ECHO Upload DECNUMS.VMARC to VM and VMARC UNPK it, then follow READCMS MD.