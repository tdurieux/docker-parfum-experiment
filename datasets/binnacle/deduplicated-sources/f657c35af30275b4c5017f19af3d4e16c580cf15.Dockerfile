FROM golang:alpine as build
RUN apk --no-cache add git
ENV PACKAGEPATH=github.com/networkservicemesh/networkservicemesh/
ENV GO111MODULE=on

RUN mkdir /root/networkservicemesh
ADD ["go.mod","/root/networkservicemesh"]
ADD ["./scripts/go-mod-download.sh","/root/networkservicemesh"]
WORKDIR /root/networkservicemesh/
RUN ./go-mod-download.sh

ADD [".","/root/networkservicemesh"]

# 1. icmp-responder-nse
FROM build as build-1
ARG VERSION=unspecified
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags "-extldflags "-static" -X  main.version=${VERSION}" -o /go/bin/icmp-responder-nse ./test/applications/cmd/icmp-responder-nse
FROM alpine as runtime-1
COPY --from=build-1 /go/bin/icmp-responder-nse /bin/icmp-responder-nse

# 2. monitoring-nsc
FROM build-1 as build-2
ARG VERSION=unspecified
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags "-extldflags "-static" -X  main.version=${VERSION}"  -o /go/bin/monitoring-nsc ./test/applications/cmd/monitoring-nsc
FROM runtime-1 as runtime-2
COPY --from=build-2 /go/bin/monitoring-nsc /bin/monitoring-nsc