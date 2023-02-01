ARG VERSION=latest
FROM alpine:${VERSION} AS build

# add edge community packages for php 8.1
RUN echo "@edge https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

# update apk repositories
RUN apk update

# add c build tools
RUN apk add --no-cache build-base

# add git
RUN apk add --no-cache git

# add php dev
RUN apk add --no-cache php81-dev@edge

# add zlib dev
RUN apk add --no-cache zlib-dev

# clone php-spx
RUN git clone https://github.com/NoiseByNorthwest/php-spx.git

# set workdir
WORKDIR /php-spx

# checkout release
RUN git checkout tags/v0.4.12

# fix ./configure "Cannot find php-config. Please use --with-php-config=PATH"
RUN ln -s /usr/bin/php-config81 /usr/bin/php-config

# build php-spx
RUN phpize81
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make

# start again with a new image
FROM scratch

# get version
ARG VERSION

# copy spx module from alpine image to the scratch image so files can be copied back to host
COPY --from=build /php-spx/modules/spx.so alpine-$VERSION/spx.so
