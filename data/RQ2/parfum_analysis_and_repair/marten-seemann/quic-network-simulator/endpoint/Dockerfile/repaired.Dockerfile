FROM ubuntu:20.04

RUN apt-get update && \
  apt-get install --no-install-recommends -y wget net-tools iputils-ping tcpdump ethtool iperf iproute2 && rm -rf /var/lib/apt/lists/*;

COPY setup.sh .
RUN chmod +x setup.sh

COPY run_endpoint.sh .
RUN chmod +x run_endpoint.sh

RUN wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && chmod +x wait-for-it.sh

ENTRYPOINT [ "/run_endpoint.sh" ]
