FROM alpine:latest as build

RUN apk add --no-cache git make musl-dev go nodejs npm zip mingw-w64-gcc

ENV GOROOT /usr/lib/go
ENV GOPATH /go
ENV PATH /go/bin:$PATH
ENV FACTORIO_ROOT /go/src/factorio-server-manager

COPY docker/build-release.sh /usr/local/bin/build-release.sh
COPY ./ $FACTORIO_ROOT

RUN mkdir -p ${GOPATH}/bin
RUN chmod u+x /usr/local/bin/build-release.sh

WORKDIR $FACTORIO_ROOT

VOLUME /build
VOLUME $FACTORIO_ROOT

RUN ["/usr/local/bin/build-release.sh"]

FROM scratch as output
COPY --from=build ${FACTORIO_ROOT}/build/* .