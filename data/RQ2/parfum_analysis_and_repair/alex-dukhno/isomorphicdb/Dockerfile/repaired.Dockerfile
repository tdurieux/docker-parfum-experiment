FROM ubuntu:20.04 as build

COPY ./ ./

RUN apt-get update \
    && apt-get install --no-install-recommends -y clang llvm make curl autoconf automake autotools-dev libtool xutils-dev wget patch && rm -rf /var/lib/apt/lists/*;

ENV SSL_VERSION=1.0.2u

RUN curl -f https://www.openssl.org/source/openssl-$SSL_VERSION.tar.gz -O && \
    tar -xzf openssl-$SSL_VERSION.tar.gz && \
    cd openssl-$SSL_VERSION && ./config && make depend && make install && \
    cd .. && rm -rf openssl-$SSL_VERSION* && rm openssl-$SSL_VERSION.tar.gz

ENV OPENSSL_LIB_DIR=/usr/local/ssl/lib \
    OPENSSL_INCLUDE_DIR=/usr/local/ssl/include \
    OPENSSL_STATIC=1

RUN curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain stable -y

ENV PATH=/root/.cargo/bin:$PATH
RUN cargo build --release

RUN mkdir -p /build-out

RUN cp target/release/isomorphicdb /build-out/

FROM ubuntu:20.04

RUN apt-get update \
    && apt-get install --no-install-recommends -y openssl && rm -rf /var/lib/apt/lists/*;

ENV RUST_LOG=debug
ENV ROOT_PATH=/var/lib/data

EXPOSE 5432

COPY --from=build /build-out/isomorphicdb /

CMD /isomorphicdb
