ARG VERSION=unspecified
ARG VENDORING
ARG GOPROXY
ARG VPP_AGENT
ARG GO_VERSION

FROM golang:${GO_VERSION}-alpine as build


ENV GOPROXY=${GOPROXY}
ENV PACKAGEPATH=github.com/networkservicemesh/networkservicemesh/forwarder
ENV GO111MODULE=on

RUN mkdir /root/networkservicemesh
ADD [".","/root/networkservicemesh"]
WORKDIR /root/networkservicemesh/forwarder
RUN VENDORING=${VENDORING} ../scripts/go-mod-download.sh

RUN CGO_ENABLED=0 GOOS=linux go build ${VENDORING} -ldflags "-extldflags '-static' -X  main.version=${VERSION}" -o /go/bin/vppagent-forwarder ./vppagent/cmd

FROM ${VPP_AGENT} as runtime
COPY --from=build /go/bin/vppagent-forwarder /bin/vppagent-forwarder
RUN rm /opt/vpp-agent/dev/etcd.conf; echo 'Endpoint: "localhost:9111"' > /opt/vpp-agent/dev/grpc.conf;echo "disabled: true" > /opt/vpp-agent/dev/telemetry.conf
COPY forwarder/vppagent/conf/vpp/startup.conf /etc/vpp/vpp.conf
COPY forwarder/vppagent/conf/supervisord/supervisord.conf /opt/vpp-agent/dev/supervisor.conf