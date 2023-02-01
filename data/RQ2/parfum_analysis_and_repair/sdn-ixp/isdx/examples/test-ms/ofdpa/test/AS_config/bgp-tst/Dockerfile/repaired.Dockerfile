FROM alectolytic/quagga-bgp-tutorial
RUN yum install -y net-tools && rm -rf /var/cache/yum
RUN yum install -y iperf && rm -rf /var/cache/yum
RUN yum install -y tcpdump && rm -rf /var/cache/yum
