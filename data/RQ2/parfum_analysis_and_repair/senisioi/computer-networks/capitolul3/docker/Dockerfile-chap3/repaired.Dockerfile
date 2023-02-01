FROM snisioi/retele:2021

MAINTAINER Sergiu Nisioi <sergiu.nisioi@fmi.unibuc.ro>

USER root

RUN apt-get update && apt-get install --no-install-recommends -y iptables iproute2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y libnetfilter-queue-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y iperf3 moreutils && rm -rf /var/lib/apt/lists/*;

COPY src/*.sh /

