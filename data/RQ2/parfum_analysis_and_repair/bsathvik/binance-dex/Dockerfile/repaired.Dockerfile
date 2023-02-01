# Ubuntu 16.04 LTS
FROM ubuntu

WORKDIR /home/

RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:bitcoin/bitcoin
RUN apt-get update
RUN apt-get install --no-install-recommends -y libdb4.8-dev libdb4.8++-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libminiupnpc-dev libzmq3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;


# expose two rpc ports for the nodes to allow outside container access
EXPOSE 4333 14333
CMD ["/bin/bash"]
