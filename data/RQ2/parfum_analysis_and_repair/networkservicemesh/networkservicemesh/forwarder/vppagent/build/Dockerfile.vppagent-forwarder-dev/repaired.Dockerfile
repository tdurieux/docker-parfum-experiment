ARG VPP_AGENT
ARG VPP_DEV
ARG REPO
ARG GO_VERSION

FROM golang:${GO_VERSION}-alpine as build
FROM ${VPP_DEV} as vpp_dev
FROM ${VPP_AGENT} as vpp_agent

ENV POSTMORTEM_DATA_LOCATION=/var/tmp/nsm-postmortem/vpp-forwarder

COPY forwarder/vppagent/conf/supervisord/supervisord-dev.conf  /opt/vpp-agent/dev/supervisor.conf
COPY forwarder/vppagent/scripts/prepare_postmortem.sh /usr/bin/prepare_postmortem.sh
COPY forwarder/vppagent/scripts/vpp_listener.py /usr/bin/vpp_listener.py

COPY --from=vpp_dev \
    /opt/vpp-agent/dev/vpp/build-root/vpp-dev_*.deb \
    /opt/vpp-agent/dev/vpp/build-root/vpp-dbg_*.deb \
    /opt/vpp-agent/dev/vpp/build-root/libvppinfra-dev_*.deb \
    /opt/vpp-agent/dev/vpp/build-root/vpp-api-python_*.deb \
 /opt/vpp/

RUN apt-get update && apt-get install --no-install-recommends -y zip python python-cffi python-enum34 python3 \
  && cd /opt/vpp/ \
  && dpkg -i libvppinfra-dev_*.deb vpp-dev_*.deb vpp-dbg_*.deb vpp-api-python_*.deb \
  && rm *.deb && rm -rf /var/lib/apt/lists/*;

RUN rm /opt/vpp-agent/dev/etcd.conf; echo 'Endpoint: "localhost:9111"' > /opt/vpp-agent/dev/grpc.conf;echo "disabled: true" > /opt/vpp-agent/dev/telemetry.conf
COPY forwarder/vppagent/conf/vpp/startup.conf /etc/vpp/vpp.conf
COPY forwarder/vppagent/conf/supervisord/supervisord.conf /opt/vpp-agent/dev/supervisor.conf

FROM golang:${GO_VERSION}-alpine as build_vpp
ARG VERSION=unspecified
ARG VENDORING
ARG GOPROXY

ENV GOPROXY=${GOPROXY}
ENV PACKAGEPATH=github.com/networkservicemesh/networkservicemesh/forwarder
ENV GO111MODULE=on

RUN mkdir /root/networkservicemesh
ADD [".","/root/networkservicemesh"]
WORKDIR /root/networkservicemesh/forwarder
RUN VENDORING=${VENDORING} ../scripts/go-mod-download.sh

RUN CGO_ENABLED=0 GOOS=linux go build ${VENDORING} -ldflags "-extldflags '-static' -X  main.version=${VERSION}" -o /go/bin/vppagent-forwarder ./vppagent/cmd

FROM vpp_agent
COPY --from=build_vpp /go/bin/vppagent-forwarder /bin/vppagent-forwarder
