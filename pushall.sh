#!/bin/sh
set -ex

for ARCH in x86_64 mips mipsel
do
    docker push korhal/stasis-$ARCH-rust:1.22.1
    docker push korhal/stasis-$ARCH-rust:latest
    docker push korhal/stasis-$ARCH-rust:nightly-2017-10-14

done
