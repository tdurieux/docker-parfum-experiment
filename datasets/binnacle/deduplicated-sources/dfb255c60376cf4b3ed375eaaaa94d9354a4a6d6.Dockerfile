ARG VPP_AGENT
ARG VPP_DEV
ARG REPO

FROM golang:alpine as build
FROM ${VPP_DEV} as vpp_dev
FROM ${VPP_AGENT} as vpp_agent

ENV POSTMORTEM_DATA_LOCATION=/var/tmp/nsm-postmortem/vpp-dataplane

COPY dataplane/vppagent/conf/supervisord/supervisord-dev.conf /etc/supervisord/supervisord.conf
COPY dataplane/vppagent/scripts/prepare_postmortem.sh /usr/bin/prepare_postmortem.sh
COPY dataplane/vppagent/scripts/vpp_listener.py /usr/bin/vpp_listener.py

COPY --from=vpp_dev \
    /opt/vpp-agent/dev/vpp/build-root/vpp-dev_*.deb \
    /opt/vpp-agent/dev/vpp/build-root/vpp-dbg_*.deb \
    /opt/vpp-agent/dev/vpp/build-root/libvppinfra-dev_*.deb \
    /opt/vpp-agent/dev/vpp/build-root/vpp-api-python_*.deb \
 /opt/vpp/

RUN apt-get update && apt-get install -y zip python python-cffi python-enum34 python3 \
  && cd /opt/vpp/ \
  && dpkg -i libvppinfra-dev_*.deb vpp-dev_*.deb vpp-dbg_*.deb vpp-api-python_*.deb \
  && rm *.deb

RUN rm /opt/vpp-agent/dev/etcd.conf; echo 'Endpoint: "localhost:9111"' > /opt/vpp-agent/dev/grpc.conf
COPY dataplane/vppagent/conf/vpp/startup.conf /etc/vpp/vpp.conf
COPY dataplane/vppagent/conf/supervisord/supervisord.conf /etc/supervisord/supervisord.conf

FROM golang:alpine as build_vpp
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

FROM vpp_agent
COPY --from=build_vpp /go/bin/vppagent-dataplane /bin/vppagent-dataplane
CMD [ "/bin/sh", "-c", "rm -f /dev/shm/db /dev/shm/global_vm /dev/shm/vpe-api &&     /usr/bin/supervisord -c /etc/supervisord/supervisord.conf"]

