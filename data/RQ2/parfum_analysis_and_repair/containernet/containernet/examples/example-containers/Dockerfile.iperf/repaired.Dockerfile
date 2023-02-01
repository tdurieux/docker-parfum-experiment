FROM ubuntu:trusty

RUN apt-get update && apt-get install --no-install-recommends -y \
    net-tools \
    iputils-ping \
    iproute2 \
    telnet telnetd \
    iperf && rm -rf /var/lib/apt/lists/*;

CMD /bin/bash
