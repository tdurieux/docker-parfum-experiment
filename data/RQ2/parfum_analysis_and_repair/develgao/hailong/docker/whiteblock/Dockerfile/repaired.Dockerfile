FROM openjdk:11.0.2-jre-slim-stretch

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y build-essential \
    tmux wget iperf3 curl apt-utils iputils-ping expect git git-extras \
    software-properties-common openssh-server && rm -rf /var/lib/apt/lists/*;

WORKDIR /
ENV PATH="/opt/hailong/bin/:${PATH}"

ENTRYPOINT ["/bin/bash"]

COPY scripts /opt/whiteblock/scripts
COPY config /opt/whiteblock/config
COPY start.sh /launch/start.sh
COPY hailong /opt/hailong

