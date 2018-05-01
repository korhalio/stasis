FROM rust:1.25.0

RUN apt update && apt install -y build-essential gcc git make sed \
  binutils patch gzip bzip2 perl tar cpio python \
  unzip rsync file bc bash g++ flex bison libc-dev \
  wget curl

RUN cd / && git clone https://github.com/korhalio/buildroot.git

ARG arch
ADD configs/$arch /buildroot/.config

RUN \
    cd /buildroot && \
    make -j10 &&\
    ln -s libgcc.a /buildroot/output/host/lib/gcc/$arch-buildroot-linux-musl/7.2.0/libgcc_s.a

RUN useradd -u 1000 dockeruser -m --shell /bin/bash
ARG rust
RUN \
    echo "$arch" > /.arch &&\
    /usr/local/cargo/bin/rustup toolchain install $rust-x86_64-unknown-linux-gnu &&\
    /usr/local/cargo/bin/rustup target add $arch-unknown-linux-musl --toolchain $rust-x86_64-unknown-linux-gnu

ADD entrypoint.sh user.sh musl-gcc.specs /

RUN cp /buildroot/output/build/musl-1.1.18/lib/crti.o \
/usr/local/rustup/toolchains/$rust-x86_64-unknown-linux-gnu/lib/rustlib/$arch-unknown-linux-musl/lib/crti.o \
&& cp /buildroot/output/build/musl-1.1.18/lib/rcrt1.o \
/usr/local/rustup/toolchains/$rust-x86_64-unknown-linux-gnu/lib/rustlib/$arch-unknown-linux-musl/lib/crt1.o \
&& cp /buildroot/output/build/musl-1.1.18/lib/crtn.o \
/usr/local/rustup/toolchains/$rust-x86_64-unknown-linux-gnu/lib/rustlib/$arch-unknown-linux-musl/lib/crtn.o

ENTRYPOINT ["/user.sh", "/entrypoint.sh"]

