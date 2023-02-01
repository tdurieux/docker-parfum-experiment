FROM ubuntu:bionic
RUN apt update && apt install --no-install-recommends -y autoconf automake build-essential git libcurl4-openssl-dev libev-dev libpthread-stubs0-dev pkg-config && rm -rf /var/lib/apt/lists/*;
WORKDIR /build
ENV URL http://localhost
COPY . .
RUN ./scripts/bootstrap
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make all
ENTRYPOINT ./src/spoa-mirror -r0 -u ${URL}
