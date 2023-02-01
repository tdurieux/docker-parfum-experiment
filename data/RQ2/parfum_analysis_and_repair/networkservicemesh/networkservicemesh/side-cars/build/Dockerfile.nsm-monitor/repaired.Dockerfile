ARG VERSION=unspecified
ARG VENDORING
ARG GOPROXY
ARG GO_VERSION

FROM golang:${GO_VERSION}-alpine as build

ENV GOPROXY=${GOPROXY}
ENV PACKAGEPATH=github.com/networkservicemesh/networkservicemesh/side-cars
ENV GO111MODULE=on

RUN mkdir /root/networkservicemesh
ADD [".","/root/networkservicemesh"]
WORKDIR /root/networkservicemesh/side-cars
RUN VENDORING=${VENDORING} ../scripts/go-mod-download.sh

RUN CGO_ENABLED=0 GOOS=linux go build ${VENDORING} -ldflags "-extldflags '-static' -X  main.version=${VERSION}" -o /go/bin/nsm-monitor ./cmd/nsm-monitor

FROM alpine as runtime
COPY --from=build /go/bin/nsm-monitor /bin/nsm-monitor
ENTRYPOINT ["/bin/nsm-monitor"]