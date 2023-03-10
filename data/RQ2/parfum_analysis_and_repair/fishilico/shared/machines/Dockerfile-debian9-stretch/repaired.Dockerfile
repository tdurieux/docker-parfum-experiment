FROM debian:stretch-slim
LABEL Description="Debian 9 Stretch with build dependencies for shared"

# Override the language to force UTF-8 output
ENV LANG=C.UTF-8

# Installing openjdk-8-jre-headless requires /usr/share/man/man1 to exist
# Debian 9 provides a version of Rust (1.24.1) which is too old
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
        openjdk-8-jdk \
        openssh-client \
        openssl \
        pkgconf \
        python3 \
        python3-cffi \
        python3-crypto \
        python3-cryptography \
        python3-dev \
        python3-gmpy2 \
        python3-nacl \
        python3-numpy \
        python3-pil \
        python-cffi \
        python-crypto \
        python-dev \
        python-gmpy2 \
        python-numpy \
        python-pil \
        python-z3 \
        sagemath \
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
#       gcc: gcc (Debian 6.3.0-18+deb9u1) 6.3.0 20170516
#       clang: clang version 3.8.1-24 (tags/RELEASE_381/final)
#       x86_64-w64-mingw32-gcc: x86_64-w64-mingw32-gcc (GCC) 6.3.0 20170516
#       i686-w64-mingw32-gcc: i686-w64-mingw32-gcc (GCC) 6.3.0 20170516
#       wine: wine-1.8.7 (Debian 1.8.7-2)
#       Linux kernel: 4.9.0-18-amd64
#       /lib/ld-musl-x86_64.so.1: musl libc (x86_64) Version 1.1.16
#       python3: Python 3.5.3
#       coqc: The Coq Proof Assistant, version 8.6 (December 2016) compiled on Dec 29 2016 23:38:14 with OCaml 4.02.3
#       openssl: OpenSSL 1.1.0l  10 Sep 2019
