#!/bin/bash -l
THIS=$(dirname $(readlink -f $0))
BR=$THIS/buildroot/
ARCH=$(cat /.arch)

export PATH="$BR/output/host/bin:$PATH"
export XSHELL="[stasis-$ARCH-for-rust] "



export CC=$ARCH-buildroot-linux-musl-gcc
export OBJCOPY=$ARCH-buildroot-linux-musl-objcopy
export RUSTFLAGS="$RUSTFLAGS -C linker=$ARCH-buildroot-linux-musl-cc -C link-arg=-lgcc_s -C link-arg=--specs=$THIS/musl-gcc.specs"

export PKG_CONFIG_SYSROOT_DIR="$BR/output/staging/"
export PKG_CONFIG_PATH="$BR/output/host/$ARCH-buildroot-linux-musl/sysroot/usr/lib/pkgconfig"
export PKG_CONFIG_ALLOW_CROSS=1
export PKG_CONFIG_ALL_STATIC=1

export CFLAGS="$CFLAGS -fPIC"
export OPENSSL_INCLUDE_DIR="$BR./output/host/$ARCH-buildroot-linux-musl/sysroot/usr/include/"
export OPENSSL_LIB_DIR="$BR./output/host/$ARCH-buildroot-linux-musl/sysroot/usr/lib/"

. /usr/local/cargo/env
cd /src
cargo build --target $ARCH-unknown-linux-musl "$@"
