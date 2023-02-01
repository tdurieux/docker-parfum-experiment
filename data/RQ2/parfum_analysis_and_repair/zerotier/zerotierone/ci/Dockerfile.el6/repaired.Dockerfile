ARG DOCKER_ARCH
FROM --platform=linux/${DOCKER_ARCH} alpine:edge AS builder

RUN apk update
RUN apk add --no-cache curl
RUN apk add --no-cache bash
RUN apk add --no-cache file
RUN apk add --no-cache rust
RUN apk add --no-cache cargo
RUN apk add --no-cache make
RUN apk add --no-cache cmake
RUN apk add --no-cache clang
RUN apk add --no-cache openssl-dev
RUN apk add --no-cache linux-headers
RUN apk add --no-cache build-base
RUN apk add --no-cache openssl-libs-static

COPY . .
RUN ZT_STATIC=1 make one
RUN ls -la

ARG DOCKER_ARCH
FROM --platform=linux/${DOCKER_ARCH} centos:6 AS stage
WORKDIR /root/rpmbuild/BUILD
COPY . .
COPY --from=builder zerotier-one ./
RUN curl -f https://gist.githubusercontent.com/someara/b363002ba6e57b3c474dd027d4daef85/raw/4ac5534139752fc92fbe1a53599a390214f69615/el6%2520vault --output /etc/yum.repos.d/CentOS-Base.repo
RUN uname -a
RUN yum -y install make gcc rpm-build && rm -rf /var/cache/yum
RUN pwd
RUN ls -la
RUN make redhat

FROM scratch AS export
ARG PLATFORM
COPY --from=stage /root/rpmbuild/RPMS/*/*.rpm ./${PLATFORM}/
