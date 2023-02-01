ARG VENDORING
ARG GOPROXY
ARG GO_VERSION

FROM golang:${GO_VERSION}-alpine as build

ENV GOPROXY=${GOPROXY}
ENV PACKAGEPATH=github.com/networkservicemesh/networkservicemesh/forwarder
ENV GO111MODULE=on

RUN mkdir /root/networkservicemesh
ADD [".","/root/networkservicemesh"]
WORKDIR /root/networkservicemesh/forwarder
RUN VENDORING=${VENDORING} ../scripts/go-mod-download.sh

RUN CGO_ENABLED=0 GOOS=linux go build ${VENDORING} -ldflags "-extldflags '-static'" -o /go/bin/kernel-forwarder ./kernel-forwarder/cmd/kernel-forwarder.go

FROM alpine as runtime
COPY --from=build /go/bin/kernel-forwarder /bin/kernel-forwarder
ENTRYPOINT ["/bin/kernel-forwarder"]