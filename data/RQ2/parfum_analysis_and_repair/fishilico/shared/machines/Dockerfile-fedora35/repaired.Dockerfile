FROM fedora:35
LABEL Description="Fedora 35 with build dependencies for shared"

# Override the language to force UTF-8 output
ENV LANG=C.UTF-8

RUN \
    dnf update -q -y --setopt=deltarpm=false && \
    dnf install -q -y --setopt=deltarpm=false \
        cargo \
        clang \
        coq \
        diffutils \
        elfutils-libelf-devel \
        gcc \
        gdb \
        glibc-devel.x86_64 \
        glibc-devel.i686 \
        gmp-devel.x86_64 \
        gmp-devel.i686 \
        gtk3-devel \
        java-11-openjdk-devel \
        kernel \
        kernel-devel \
        libmnl-devel.i686 \
        libmnl-devel.x86_64 \
        m4 \
        make \
        mingw32-gcc \
        mingw64-gcc \
        numpy \
        openssh \
        openssl \
        openssl-devel \
        perl-Getopt-Long \
        perl-Term-ANSIColor \
        pkgconf \
        pulseaudio-libs-devel \
        python-unversioned-command \
        python3 \
        python3-cffi \
        python3-cryptography \
        python3-devel \
        python3-gmpy2 \
        python3-numpy \
        python3-pillow \
        python3-pycryptodomex \
        python3-pynacl \
        python3-z3 \
        python2-devel \
        SDL2-devel \
        which \
        wine \
        xorg-x11-server-Xvfb && \
    dnf clean all

WORKDIR /shared
RUN ln -s shared/machines/run_shared_test.sh /run_shared_test.sh
COPY . /shared/

CMD ["xvfb-run", "/run_shared_test.sh"]

# make list-nobuild:
#    Global blacklist: latex%
#    In sub-directories:
#       c:
#       glossaries:
#       java/keystore:
#       linux:
#       python:
#       python/crypto:
#       python/network:
#       python/network/dnssec:
#       python/qrcode:
#       rust:
#       verification:
#    With gcc -m32:
#       Global blacklist: latex%
#       In sub-directories:
#          c: gtk_alpha_window
#          glossaries:
#          java/keystore:
#          linux: pulseaudio_echo sdl_v4l_video
#          python:
#          python/crypto:
#          python/network:
#          python/network/dnssec:
#          python/qrcode:
#          rust:
#          verification:
#    Compilers:
#       gcc -m64: ok
#       gcc -m32: ok
#       clang -m64: ok
#       clang -m32: ok
#       musl-gcc: not working
#       x86_64-w64-mingw32-gcc: ok
#       i686-w64-mingw32-gcc: ok
#    Versions:
#       gcc: gcc (GCC) 11.2.1 20220127 (Red Hat 11.2.1-9)
#       clang: clang version 13.0.0 (Fedora 13.0.0-3.fc35)
#       x86_64-w64-mingw32-gcc: x86_64-w64-mingw32-gcc (GCC) 11.2.1 20210728 (Fedora MinGW 11.2.1-3.fc35)
#       i686-w64-mingw32-gcc: i686-w64-mingw32-gcc (GCC) 11.2.1 20210728 (Fedora MinGW 11.2.1-3.fc35)
#       wine: wine-7.2 (Staging)
#       Linux kernel: 5.16.16-200.fc35.x86_64
#       /lib/ld-linux.so.2: ld.so (GNU libc) stable release version 2.34.
#       python: Python 3.10.3
#       python3: Python 3.10.3
#       javac: javac 11.0.14.1
#       java: openjdk 11.0.14.1 2022-02-08
#       rustc: rustc 1.59.0 (Fedora 1.59.0-2.fc35)
#       cargo: cargo 1.59.0
#       coqc: The Coq Proof Assistant, version 8.13.2 (July 2021) compiled on Jul 29 2021 0:00:00 with OCaml 4.12.0
#       openssl: OpenSSL 1.1.1n  FIPS 15 Mar 2022