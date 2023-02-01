# download and build giflossy
FROM alpine:3.8 AS build
RUN apk add --no-cache curl autoconf automake make build-base
RUN curl -f -SL https://github.com/kornelski/giflossy/archive/1.91.tar.gz | tar xzv
RUN cd giflossy-1.91 && autoreconf -i && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make install
RUN cp "$(which gifsicle)" /gifsicle

# app image
FROM alpine:3.8
RUN apk add --no-cache "imagemagick>=7.0.7.32-r0"
COPY --from=build /gifsicle /bin/gifsicle
COPY gif.sh /ezrgif
ENTRYPOINT ["/ezrgif"]
