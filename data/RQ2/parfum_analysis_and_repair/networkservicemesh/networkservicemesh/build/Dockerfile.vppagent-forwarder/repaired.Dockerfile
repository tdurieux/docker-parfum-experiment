ARG VPP_AGENT
FROM ${VPP_AGENT} as runtime
RUN rm /opt/vpp-agent/dev/etcd.conf; echo "disabled: true" > /opt/vpp-agent/dev/linux-plugin.conf
RUN  mkdir -p /run/vpp
COPY startup.conf /etc/vpp/vpp.conf
COPY supervisord.conf /opt/vpp-agent/dev/supervisor.conf
RUN  mkdir -p /etc/govpp
COPY govpp.conf /etc/govpp/govpp.conf
COPY telemetry.conf /opt/vpp-agent/dev/telemetry.conf
COPY ["vppagent-forwarder", "/bin/"]
RUN mkdir -p /tmp/vpp/
RUN echo 'Endpoint: "localhost:9111"' > /opt/vpp-agent/dev/grpc.conf