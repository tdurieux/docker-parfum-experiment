FROM golang:1.11-alpine3.8 as build

RUN set -ex \
	&& apk add --no-cache --virtual .build-deps \
    bash \
    git  \
    make \
	\
	&& rm -rf /*.patch

ENV GOPATH /go
ENV GOROOT /usr/local/go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

COPY . /go/src/github.com/lastbackend/lastbackend
WORKDIR /go/src/github.com/lastbackend/lastbackend/cmd/plugins/docker

RUN go build --ldflags '-extldflags "-static"' -o /usr/bin/lastbackend

WORKDIR /go/bin
RUN rm -rf /go/pkg \
    && rm -rf /go/src \
    && rm -rf /var/cache/apk/*


# Production manifest
FROM alpine:3.8 as production
COPY --from=build /usr/bin/lastbackend /usr/bin/lastbackend
ENTRYPOINT /usr/bin/lastbackend