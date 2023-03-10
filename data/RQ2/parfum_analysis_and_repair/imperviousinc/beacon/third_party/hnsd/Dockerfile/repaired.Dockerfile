FROM alpine AS base
COPY . /

FROM base AS build
RUN apk add --no-cache \
  build-base \
  git \
  automake \
  autoconf \
  libtool \
  unbound-dev
RUN ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make

FROM base
RUN apk add --no-cache unbound-libs
COPY --from=build /hnsd /usr/local/bin/hnsd

ENTRYPOINT ["/usr/local/bin/hnsd"]
CMD []
