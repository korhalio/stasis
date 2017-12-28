Stasis
======

build static position-independant-executables without any runtime requirements
static for real. not even needs libc or dynloader.

the resulting executables can be run on anything running a linux kernel,
no matter which libc is installed.


available architectures:
 - x86_64
 - mips
 - mipsel

available rust versions:
 - 1.22.1 (default when no tag specified)
 - nightly-2017-10-14


```
docker run -v $PWD:/src korhal/stasis-x86_64-rust:1.22.1 --release
```


Troubleshooting
==============

__undefined reference to something something__

gnu ld depends on specific order of dependencies, which rust doesn't always do.
however, gnuld also allows specifying a dependency multiple times, so you can just add the lib again
with -e 'RUSTFLAGS=-C link-arg=-lz'

