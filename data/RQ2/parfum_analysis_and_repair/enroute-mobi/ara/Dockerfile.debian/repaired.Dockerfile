# docker run -v $PWD/target:/target ara-build

# ARG DEBIAN_VERSION=jessie
FROM debian:jessie-slim

ARG WEEK

RUN apt-get update && apt-get -y dist-upgrade && \
    apt-get install -y --no-install-recommends devscripts fakeroot equivs && \
    mkdir /build && rm -rf /var/lib/apt/lists/*;

WORKDIR /build
COPY . /build

ENV DEBIAN_FRONTEND=noninteractive

ENV GOLANG_VERSION=1.12.7
ENV BUILD_NUMBER=""
ENV BUILD_BRANCH=""

VOLUME /target
CMD ["./build-debian.sh", "/target"]
