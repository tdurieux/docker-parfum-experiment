FROM alpine:3.11
ARG MAKE_OPTS=-j12
ARG SDL_VERSION

RUN apk add --no-cache autoconf automake build-base cdrkit gzip libtool linux-headers pkgconf zip

COPY vendor/SDL2-${SDL_VERSION}.tar.gz /tmp/
RUN cd /tmp \
 && tar xzf SDL2-${SDL_VERSION}.tar.gz \
 && cd SDL2-${SDL_VERSION} \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
 && make ${MAKE_OPTS} \
 && make install \
 && echo "/usr/local/share/aclocal" > /usr/share/aclocal/dirlist \
 && rm -rf /tmp/SDL2-${SDL_VERSION}* && rm SDL2-${SDL_VERSION}.tar.gz
