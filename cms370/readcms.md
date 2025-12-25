# decNumber for VM/370 R6 CMS

This is [Mike Cowlishaw](https://speleotrove.com/)'s
[`decNumber`](https://speleotrove.com/decimal/decNumber-icu-368.zip)
[General Decimal Arithmetic](https://speleotrove.com/decimal/) library, ported
to VM/370 CMS.  Mike released his work under the
[International Components for Unicode (ICU)](https://speleotrove.com/decimal/ICU-license.html)
license.


## Differences from Mike Cowlishaw's `decNumber` version 3.68 code

Almost all of Mike's code is in this package unchanged.  Only 3 files were
changed, in each case to `#include "decCMS.h"` if the code is being compiled on
CMS.  Those files are `decContext.h`, `decNumber.h`, and `decQuad.h`.
Everything else is unchanged from his 3.68 (2010-02-10) release.

Almost everything in the `cms370` directory was created by Ross Patterson to
make Mike's library build and run in the VM/370 CMS environment.  The only
exceptions are `stdint.h`, which Mike provided at
https://speleotrove.com/decimal/dnusers.html and `stdio.h`, which fixes a bug
discovered by `decNumber`[GCCLIB Issue #59]
(https://github.com/adesutherland/CMS-370-GCCLIB/issues/59).  All of Ross's
work on `decNumber` is dedicated to the public domain.  If you need a license
to refer to, please use [the Unlicense](https://unlicense.org/).

In order to build `decNumber` for VM/370 R6 CMS, no significant changes to it
were necessary, but some additions were required.

1. A `CMS EXEC` script was needed to compile the code.  `cms370/build.exec` is
   based on Mike's original `build.sh`.

2. All files with fileids longer than 8 characters had to be renamed, because
   the CMS filesystem is 8.8.  The `cms370/prepare_source.bat` and
   `cms370/prepare_source.sh` scripts to do that for Windows and Linux,
   respectively.  These scripts require the `sed` stream-editor, and produce
   a new `prep_src` directory containing the full source code, updated as
   follows:

   1. Rename the few files named `decimalWhatever.*` to `dnWhatever.*`

   2. Rename `decNumberLocal.h` to `dnLocal.h`.

   3. Rename the files named `decWhatever.*` to `dnWhtevr.*`, removing
      characters as necessary to make them short enough.

   4. Edit all the `#include` directives to use the new filenames.

3. The `stdio.h` file in the VM/370 CMS GCC library has a syntax error that
   only shows up with the `-Wall` option, which almost nobody uses because C
   programmers ignore most warnings.  It's in a comment, so it doesn't hurt
   anything.  But GCC logs a warning when compiling every file in this
   package.  So an updated `stdio.h` file is included in the `cms370`
   directory.  It can be removed when [GCCLIB Issue #59]
   (https://github.com/adesutherland/CMS-370-GCCLIB/issues/59) is fixed.

4. This `readcms.md` file needed to be written.

5. A new C preprocessor file, `cms370/decShortNames.h` (or `dnShNm.h`, after
   the renaming above) uses the `#define` directive to shorten all function
   names to 7 characters, as required for the CMS GCC compiler and `TXTLIB`
   command.

6. The `cms370/mkupload.bat` and `cms370/mkupload.sh` scripts build a
   source-code
   [VMARC](https://www.ibm.com/support/pages/zvm/devpages/bkw/vmarc.html)
   archive for upload to VM.  These scripts require Leland Lucius's `vma`
   program from https://www.homerow.net/zvm/vma/.  You can use whatever
   technique you prefer to upload the source files, but this is what Ross uses.

Steps 1 through 4 above were one-time changes, and are already present in
releases of this package at GitHub.  If you choose to clone the repository
instead of using those releases, you should follow the steps in
[Installing from source](#installing-from-source) below.

## Using `decNumber`

To use `decNumber` on VM/370 CMS, you have to do the following:

1. Anywhere the
   [`decNumber` documentation](https://speleotrove.com/decimal/decnumber.pdf)
   says to include `decWhatever.h`, include `dnWhtevr.h` instead.  Likewise
   `decimalWhatever.h` and `dnWhatever.h`.  You should never need to include
   `decNumberLocal.h`, but if you do, include `dnLocal.h` instead.  See the
   [list of renamed header files](#list-of-renamed-header-files) below for the
   exact names.

2. Make the library available to link with your program after you compile it:

   `GLOBAL TXTLIB DECNUM GCCLIB ...`

3. The pre-compiled `DECNUM TXTLIB` is generated with the the following
   customization and tuning parameters, as set in `cms370/decCMS.h`, or
   defaulted by `decNumber` as per the documentation's "_Additional options_"
   section:

   * Customization:
     * `DECEXTFLAG`=1 (default) - Extended flags are good, apparently.
     * `DECLITEND`=0 - VM/370 is a big-endian system.  This cannot be overridden
       and must not be changed.
     * `DECSUBSET`=0 (default) - Improves performance, per documentation.
     * `DECUSE64`=0 - VM/370 C doesn't have 64-bit integers.  This cannot be
       overridden and must not be changed.
   * Tuning:
     * `DECBUFFER`=36 (default) - Recommended by documentation.
     * `DECDPUN`=3 (default) - Recommended by documentation.
     * `DECNUMDIGITS`=32 - Seems like plenty, maybe?  Default of 1 seems a bad
       choice.
   * Printing and testing:
     * `DECALLOC`=0 (default) - For normal operations.
     * `DECCHECK`=0 (default) - For normal operations.
     * `DECPRINT`=1 (default) - For normal operations.
     * `DECTRACE`=0 (default) - For normal operations.

  If you want to change any of them, you must recompile all of `decNumber`.  If
  you change `DECNUMDIGITS` or `DECDPUN`, you must recompile any code that
  declares a `decNumber` variable.

## Installing `decNumber`

To install `decNumber` on VM/370 CMS, you have to do the following:

### Installing from a pre-built package

1. Download the `decNumber.zip` release ZIP file from
   https://github.com/RossPatterson/decNumber/releases.

2. Unzip the `decNumber.zip` file.

3. Upload the resulting `decnumb.vmarc` file to CMS in binary, recfm=F,
   lrecl=80.

4. Unpack the files:

   `VMARC UNPK DECNUMB VMARC A * * A ( OLDDATE`

5. Put the library somewhere code can use it (_e.g._, the Y-disk):

   `COPYFILE DECNUM TXTLIB A = = public_fm ( OLDDATE`
   `COPYFILE * H A  = = public_fm ( OLDDATE`

### Installing from source package

To build decNumber for VM/370 CMS from the source from a release package
yourself, you have to do the following:

1. Download the `decNumber.zip` release ZIP file from
   https://github.com/RossPatterson/decNumber/releases.

2. Unzip the `decNumber.zip` file.

3. Upload the resulting `decnums.vmarc` file to CMS in binary, recfm=F,
   lrecl=80.

4. Unpack the files on CMS:

   `VMARC UNPK DECNUMS VMARC A * * A ( OLDDATE`

5. Build the package on CMS:

   `BUILD`

6. Put the library somewhere code can use it (_e.g._, the Y-disk):

   `COPYFILE DECNUM TXTLIB A = = public_fm ( OLDDATE`
   `COPYFILE * H A  = = public_fm ( OLDDATE`

### Installing from GitHub source

To build decNumber for VM/370 CMS from source yourself, using the source online
at GitHub, you have to do the following:

1. Download the source files from GitHub:

   `git clone https://github.com/RossPatterson/decNumber.git`
   `cd decNumber`

2. Make the upload file:
  * On Windows:

     `.\cms370\prepare_source.bat`
     `.\cms370\mkupload.bat`

  * On Unix/Linux/_etc._:

     `./cms370/prepare_source.sh`
     `./cms370/mkupload.sh`

3. Upload the resulting `decnums.vmarc` file to CMS in binary, recfm=F,
   lrecl=80.

4. Unpack the files on CMS:

   `VMARC UNPK DECNUMS VMARC A * * A ( OLDDATE`

5. Build the package on CMS:

   `BUILD`

6. Put the library somewhere code can use it (_e.g._, the Y-disk):

   `COPYFILE DECNUM TXTLIB A = = public_fm ( OLDDATE`
   `COPYFILE * H A  = = public_fm ( OLDDATE`

## List of renamed header files

* decBasic.c -------> dnBasic.c
* decCMS.h ---------> dnCMS.h
* decCommon.c ------> dnCommon.c
* decContext.c -----> dnCtxt.c
* decContext.h -----> dnCtxt.h
* decDPD.h ---------> dnDPD.h
* decDouble.c ------> dnDouble.c
* decDouble.h ------> dnDouble.h
* decNumber.c ------> dnNumber.c
* decNumber.h ------> dnNumber.h
* decNumberLocal.h -> dnLocal.h
* decPacked.c ------> dnPacked.c
* decPacked.h ------> dnPacked.h
* decQuad.c --------> dnQuad.c
* decQuad.h --------> dnQuad.h
* decShortNames.h --> dnShnm.h
* decSingle.c ------> dnSingle.c
* decSingle.h ------> dnSingle.h
* decimal128.c -----> dn128.c
* decimal128.h -----> dn128.h
* decimal32.c ------> dn32.c
* decimal32.h ------> dn32.h
* decimal64.c ------> dn64.c
* decimal64.h ------> dn64.h

