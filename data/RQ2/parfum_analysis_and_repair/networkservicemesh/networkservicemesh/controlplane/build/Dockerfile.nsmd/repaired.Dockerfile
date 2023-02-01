ARG VERSION=unspecified
ARG VENDORING
ARG GOPROXY
ARG GO_VERSION

FROM golang:${GO_VERSION}-alpine as build

ENV GOPROXY=${GOPROXY}
ENV PACKAGEPATH=github.com/networkservicemesh/networkservicemesh/controlplane
ENV GO111MODULE=on

RUN mkdir /root/networkservicemesh
ADD [".","/root/networkservicemesh"]
WORKDIR /root/networkservicemesh/controlplane
RUN VENDORING=${VENDORING} ../scripts/go-mod-download.sh

RUN CGO_ENABLED=0 GOOS=linux go build ${VENDORING} -ldflags "-extldflags '-static' -X  main.version=${VERSION}" -o /go/bin/nsmd ./cmd/nsmd

FROM alpine as runtime
COPY --from=build /go/bin/nsmd /bin/nsmd
ENTRYPOINT ["/bin/nsmd"]