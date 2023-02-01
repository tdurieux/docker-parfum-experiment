ARG VPP_AGENT

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

FROM ${VPP_AGENT} as runtime
RUN rm /opt/vpp-agent/dev/etcd.conf; echo "disabled: true" > /opt/vpp-agent/dev/linux-plugin.conf
COPY dataplane/vppagent/conf/vpp/startup.conf /etc/vpp/vpp.conf
COPY test/applications/vpp-conf/supervisord.conf /etc/supervisord/supervisord.conf
COPY test/applications/vpp-conf/run.sh /bin/vpp-run.sh

RUN mkdir /tmp/vpp/

# 1. vppagent-nsc
FROM build as build-1
ARG VERSION=unspecified
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags "-extldflags "-static" -X  main.version=${VERSION}" -o /go/bin/vppagent-nsc ./test/applications/cmd/vppagent-nsc
FROM runtime as runtime-1
COPY --from=build-1 /go/bin/vppagent-nsc /bin/vppagent-nsc
RUN mkdir /tmp/vpp/vppagent-nsc/; echo 'Endpoint: "0.0.0.0:9113"' > /tmp/vpp/vppagent-nsc/grpc.conf

# 2. vppagent-icmp-responder-nse
FROM build-1 as build-2
ARG VERSION=unspecified
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags "-extldflags "-static" -X  main.version=${VERSION}" -o /go/bin/vppagent-icmp-responder-nse ./test/applications/cmd/vppagent-icmp-responder-nse
FROM runtime-1 as runtime-2
COPY --from=build-2 /go/bin/vppagent-icmp-responder-nse /bin/vppagent-icmp-responder-nse
RUN mkdir /tmp/vpp/vppagent-icmp-responder-nse/; echo 'Endpoint: "0.0.0.0:9112"' > /tmp/vpp/vppagent-icmp-responder-nse/grpc.conf

# 3. vppagent-firewall-nse
FROM build-2 as build-3
ARG VERSION=unspecified
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags "-extldflags "-static" -X  main.version=${VERSION}" -o /go/bin/vppagent-firewall-nse ./test/applications/cmd/vppagent-firewall-nse
FROM runtime-2 as runtime-3
COPY --from=build-3 /go/bin/vppagent-firewall-nse /bin/vppagent-firewall-nse
RUN mkdir /tmp/vpp/vppagent-firewall-nse/; echo 'Endpoint: "0.0.0.0:9112"' > /tmp/vpp/vppagent-firewall-nse/grpc.conf
