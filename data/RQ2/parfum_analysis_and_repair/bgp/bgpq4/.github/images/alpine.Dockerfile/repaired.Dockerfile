ARG image=alpine:latest
FROM $image

# Install dependencies
RUN apk upgrade
RUN apk add --no-cache autoconf automake file gcc gzip libtool make musl-dev

# Add source code
ADD . /src
WORKDIR /src

# Run steps
RUN ./bootstrap
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make
RUN make check
RUN make distcheck
