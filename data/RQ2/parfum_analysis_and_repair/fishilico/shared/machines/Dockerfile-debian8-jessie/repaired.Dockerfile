FROM debian:jessie-slim
LABEL Description="Debian 8 Jessie with build dependencies for shared"

# Override the language to force UTF-8 output
ENV LANG=C.UTF-8

# Debian<9 does not provide python-z3
# Installing openjdk-7-jre-headless requires /usr/share/man/man1 to exist
# Debian 8 provides a version of Rust (1.24.1) which is too old
RUN \
    export DEBIAN_FRONTEND=noninteractive && \
    dpkg --add-architecture i386 && \
    apt-get -qq update && \
    mkdir -p /usr/share/man/man1 && \
    apt-get install --no-install-recommends --no-install-suggests -qqy \
        binutils-mingw-w64 \
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
        linux-headers-amd64 \
        make \
        musl-dev \
        musl-tools \
        openjdk-7-jdk \
        openssh-client \
        openssl \
        pkgconf \
        python3 \
        python3-cffi \
        python3-crypto \
        python3-cryptography \
        python3-dev \
        python3-gmpy2 \
        python3-numpy \
        python3-pil \
        python-argparse \
        python-cffi \
        python-crypto \
        python-dev \
        python-gmpy2 \
        python-numpy \
        python-pil \
        wine \
        wine32 \
        wine64 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /shared
RUN ln -s shared/machines/run_shared_test.sh /run_shared_test.sh
COPY . /shared/

CMD ["/run_shared_test.sh"]

# make list-nobuild:
#    Global blacklist: latex% rust%
#    In sub-directories:
#       c:
#       glossaries: check_sort_order.py
#       java/keystore: parse_jceks.py parse_pkcs12.py util_asn1.py
#       linux:
#       python: clang_cfi_typeid.py z3_example.py
#       python/crypto: bip32_seed_derivation.py chacha20_poly1305_tests.py dhparam_tests.py dsa_tests.py ec_tests.py eth_functions_keccak.py parse_openssl_enc.py rsa_tests.py
#       python/network:
#       python/network/dnssec: verify_dnssec.py
#       python/qrcode:
#       verification:
#    With gcc -m32:
#       Global blacklist: latex% rust%
#       In sub-directories:
#          c: gmp_functions gtk_alpha_window
#          glossaries: check_sort_order.py
#          java/keystore: parse_jceks.py parse_pkcs12.py util_asn1.py
#          linux: enum_link_addrs pulseaudio_echo sdl_v4l_video
#          python: clang_cfi_typeid.py z3_example.py
#          python/crypto: bip32_seed_derivation.py chacha20_poly1305_tests.py dhparam_tests.py dsa_tests.py ec_tests.py eth_functions_keccak.py parse_openssl_enc.py rsa_tests.py
#          python/network:
#          python/network/dnssec: verify_dnssec.py
#          python/qrcode:
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
#       gcc: gcc (Debian 4.9.2-10+deb8u2) 4.9.2
#       clang: Debian clang version 3.5.0-10 (tags/RELEASE_350/final) (based on LLVM 3.5.0)
#       x86_64-w64-mingw32-gcc: x86_64-w64-mingw32-gcc (GCC) 4.9.1
#       i686-w64-mingw32-gcc: i686-w64-mingw32-gcc (GCC) 4.9.1
#       wine: wine-1.6.2
#       Linux kernel: 3.16.0-11-amd64
#       /lib/ld-musl-x86_64.so.1: musl libc Version 1.1.5
#       python3: Python 3.4.2
#       coqc: The Coq Proof Assistant, version 8.4pl4 (July 2014) compiled on Jul 27 2014 13:34:24 with OCaml 4.01.0
#       openssl: OpenSSL 1.0.1t  3 May 2016
