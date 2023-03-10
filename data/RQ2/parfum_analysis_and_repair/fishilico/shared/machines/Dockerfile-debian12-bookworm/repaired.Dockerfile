FROM debian:bookworm-slim
LABEL Description="Debian 12 Bookworm with build dependencies for shared"

# Override the language to force UTF-8 output
ENV LANG=C.UTF-8

# Install apt-utils first, in order to apply package configuration tasks
# Install wine last, because otherwise apt fails to configure it
# Debian 12 removed sagemath because it failed to build from source
RUN \
    export DEBIAN_FRONTEND=noninteractive && \
    dpkg --add-architecture i386 && \
    apt-get -qq update && \
    apt-get install --no-install-recommends --no-install-suggests -qqy apt-utils && \
    apt-get install --no-install-recommends --no-install-suggests -qqy \
        binutils-mingw-w64 \
        cargo \
        clang \
        coq \
        gcc-mingw-w64 \
        gcc-multilib \
        gdb \
        libc-dev \
        libc6-dev-i386 \
        libgmp-dev \
        libgtk-3-dev \
        libmnl-dev \
        libpulse-dev \
        libsdl2-dev \
        libssl-dev \
        linux-headers-amd64 \
        m4 \
        make \
        musl-dev \
        musl-tools \
        openjdk-11-jdk \
        openssh-client \
        openssl \
        pkgconf \
        python3 \
        python3-cffi \
        python3-cryptography \
        python3-dev \
        python3-gmpy2 \
        python3-nacl \
        python3-numpy \
        python3-pil \
        python3-pycryptodome \
        python3-z3 && \
    apt-get install --no-install-recommends --no-install-suggests -qqy \
        wine \
        wine32 \
        wine64 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /shared
RUN ln -s shared/machines/run_shared_test.sh /run_shared_test.sh
COPY . /shared/

CMD ["/run_shared_test.sh"]

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
#          c: gmp_functions gtk_alpha_window
#          glossaries:
#          java/keystore:
#          linux: enum_link_addrs pulseaudio_echo sdl_v4l_video
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
#       musl-gcc: ok
#       x86_64-w64-mingw32-gcc: ok
#       i686-w64-mingw32-gcc: ok
#    Versions:
#       gcc: gcc (Debian 11.3.0-3) 11.3.0
#       clang: Debian clang version 13.0.1-6
#       x86_64-w64-mingw32-gcc: x86_64-w64-mingw32-gcc (GCC) 10-win32 20220324
#       i686-w64-mingw32-gcc: i686-w64-mingw32-gcc (GCC) 10-win32 20220324
#       wine: wine-6.0.3 (Debian 6.0.3~repack-1)
#       Linux kernel: 5.18.0-1-amd64
#       /lib/ld-linux.so.2: ld.so (Debian GLIBC 2.33-7) release release version 2.33.
#       /lib/ld-musl-x86_64.so.1: musl libc (x86_64) Version 1.2.3
#       python3: Python 3.10.5
#       javac: javac 11.0.14.1
#       java: openjdk 11.0.14.1 2022-02-08
#       rustc: rustc 1.58.1
#       cargo: cargo 1.56.0
#       coqc: The Coq Proof Assistant, version 8.15.1 compiled with OCaml 4.13.1
#       openssl: OpenSSL 3.0.3 3 May 2022 (Library: OpenSSL 3.0.3 3 May 2022)
