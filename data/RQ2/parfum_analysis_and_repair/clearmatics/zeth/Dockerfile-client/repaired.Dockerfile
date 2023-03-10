# Image to copy solc compiler from
FROM ethereum/solc:0.8.1-alpine as solc-0.8.1

FROM python:3.8-alpine3.12

LABEL org.opencontainers.image.source https://github.com/clearmatics/zeth

# Image to copy solc compiler from
COPY --from=solc-0.8.1 /usr/local/bin/solc /root/.solcx/solc-v0.8.1

RUN apk --update --no-cache add \
    build-base \
    linux-headers \
    curl \
    make \
    perl \
    gcc \
    tar \
    libffi-dev \
    python3-dev \
    py3-virtualenv \
    bash

# Copy necessary files in the docker container
COPY ./client /home/zeth/client
COPY ./proto /home/zeth/proto

ENV OPENSSL_VERSION="1.1.1g"
ENV BUILD_ROOT="/home/zeth/client"
RUN cd ${BUILD_ROOT} \
    # && virtualenv env \
    # && . env/bin/activate \
    && pip install --no-cache-dir -U setuptools \
    && pip install --no-cache-dir -U wheel pip \
    && curl -f -O https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz \
    && tar xvf openssl-${OPENSSL_VERSION}.tar.gz \
    && cd openssl-${OPENSSL_VERSION} \
    && ./config no-shared no-ssl2 no-ssl3 -fPIC --prefix=${BUILD_ROOT}/openssl \
    && make -j"$($(nproc)+1)" && make install && rm openssl-${OPENSSL_VERSION}.tar.gz

WORKDIR /home/zeth/client

# WARNING:
# The installation will only succeed if the built cryptography wheel is for the
# same version of the cryptography package as the one documented in `setup.py`.
# If not, `make setup` will try to install the right version, which will fail.
# To avoid this, we create a `constraints.txt` file that constrains the version
# of `cryptography` extracted from the `setup.py` file
RUN grep -o "cryptography==[^\"]*" setup.py > constraints.txt

RUN CFLAGS="-I${BUILD_ROOT}/openssl/include" LDFLAGS="-L${BUILD_ROOT}/openssl/lib" pip wheel --wheel-dir wheels -c constraints.txt --no-binary :all: cryptography

RUN virtualenv env \
    && source env/bin/activate \
    && pip install --no-cache-dir --no-index --find-links=wheels cryptography \
    && make setup

# Clean the container
RUN rm openssl-1.1.1g.tar.gz
RUN rm -r openssl-1.1.1g

CMD ["/bin/bash"]
