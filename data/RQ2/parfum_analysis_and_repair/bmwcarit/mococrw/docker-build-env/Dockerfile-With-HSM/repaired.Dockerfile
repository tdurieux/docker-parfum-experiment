FROM buildenv

# Install MoCOCrW dependencies (except OpenSSL)
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install \
        # libp11 engine
        libengine-pkcs11-openssl \
        # headers for p11 engine
        libp11-dev \
        # for pkcs11-tool which we use to create keys in token
        opensc \
        # p11-kit-modules allows loading of libp11 engine without having to edit openssl.cnf
        p11-kit-modules \
        # softhsm2: includes both softhsm2-util and libsofthsm2
        softhsm2 \
        && rm -rf /var/lib/apt/lists/*