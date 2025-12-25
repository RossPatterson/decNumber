#!/bin/bash

# Requires "vma" from https://www.homerow.net/zvm/vma/.

# Show the commands
set -x

rm DECNUMS.VMARC 2>/dev/null

# Exit if there is an error
set -e

pushd prep_src
for F in * ; do vma -a -t ../DECNUMS.VMARC $F ; done
popd

echo Upload DECNUMS.VMARC to VM and VMARC UNPK it, then follow READCMS MD.