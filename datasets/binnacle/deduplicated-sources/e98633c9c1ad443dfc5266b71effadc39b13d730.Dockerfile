ARG VPP_AGENT

FROM golang:alpine as build
ARG VERSION=unspecified
RUN apk --no-cache add git
ENV PACKAGEPATH=github.com/networkservicemesh/networkservicemesh/
ENV GO111MODULE=on

RUN mkdir /root/networkservicemesh
ADD ["go.mod","/root/networkservicemesh"]
ADD ["./scripts/go-mod-download.sh","/root/networkservicemesh"]
WORKDIR /root/networkservicemesh/
RUN ./go-mod-download.sh

ADD [".","/root/networkservicemesh"]
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags "-extldflags "-static" -X  main.version=${VERSION}" -o /go/bin/vppagent-dataplane ./dataplane/vppagent/cmd

FROM ${VPP_AGENT} as runtime
COPY --from=build /go/bin/vppagent-dataplane /bin/vppagent-dataplane
RUN rm /opt/vpp-agent/dev/etcd.conf; echo 'Endpoint: "localhost:9111"' > /opt/vpp-agent/dev/grpc.conf
COPY dataplane/vppagent/conf/vpp/startup.conf /etc/vpp/vpp.conf
COPY dataplane/vppagent/conf/supervisord/supervisord.conf /etc/supervisord/supervisord.conf

