#!/bin/sh
set -ex

for ARCH in x86_64 mips mipsel
do
    docker build --build-arg arch=$ARCH --build-arg rust=1.25.0  .  -t korhal/stasis-$ARCH-rust:1.25.0
    docker tag korhal/stasis-$ARCH-rust:1.25.0 korhal/stasis-$ARCH-rust:latest
    docker build --build-arg arch=$ARCH --build-arg rust=nightly-2017-10-14  .  -t korhal/stasis-$ARCH-rust:nightly-2017-10-14
done
