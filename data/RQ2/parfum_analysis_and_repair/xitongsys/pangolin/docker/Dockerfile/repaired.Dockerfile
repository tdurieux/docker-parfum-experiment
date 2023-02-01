FROM ubuntu
USER root
WORKDIR /pangolin
ENTRYPOINT bash /pangolin/start.sh

RUN apt update && apt install --no-install-recommends -y iproute2 iptables net-tools dos2unix && rm -rf /var/lib/apt/lists/*;
COPY pangolin /pangolin
RUN chmod 777 /pangolin/main
RUN dos2unix /pangolin/start.sh
