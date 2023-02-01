FROM ubuntu
RUN apt-get update
#RUN apt-get install -y build-essential git
RUN apt-get install --no-install-recommends -y wget iftop iproute2 netcat-openbsd dstat mtr net-tools sendip tcpreplay netperf iperf iperf3 fping iputils-ping tcpdump iptraf && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y graphviz && rm -rf /var/lib/apt/lists/*;
RUN echo 'bind "\C-n":history-search-backward' >> ~/.bashrc
