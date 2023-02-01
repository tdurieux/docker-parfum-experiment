FROM ubuntu

# Install ifconfig and iperf3
RUN apt-get -q update
RUN apt-get install --no-install-recommends -y net-tools iperf3 iputils-ping ethtool tcpdump tmux iproute2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -q update

