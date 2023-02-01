FROM ubuntu:18.04

RUN apt-get update

RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y software-properties-common python-software-properties && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository ppa:bitcoin/bitcoin
RUN apt-get update

RUN apt-get install --no-install-recommends -y libdb4.8-dev libdb4.8++-dev libtool autotools-dev automake pkg-config libssl-dev libevent-dev \
    bsdmainutils git libboost-all-dev libminiupnpc-dev libqt5gui5 libqt5core5a libqt5webkit5-dev libqt5dbus5 qttools5-dev qttools5-dev-tools \
    libprotobuf-dev protobuf-compiler libqrencode-dev zlib1g-dev libseccomp-dev libcap-dev libncap-dev && rm -rf /var/lib/apt/lists/*;

#verge
RUN mkdir /root/VERGE
RUN git clone https://github.com/vergecurrency/VERGE /root/VERGE
RUN cd /root/VERGE/ ; /root/VERGE/autogen.sh
RUN cd /root/VERGE/ ; /root/VERGE/configure
RUN cd /root/VERGE/ ; make

RUN chmod 0777 /root/VERGE/src/*

ADD ./conf/VERGE.conf /root/.VERGE/VERGE.conf

WORKDIR /root/VERGE

EXPOSE 21102 20102

#CMD printenv | grep -v "yyyyyxxxx" >> /etc/environment && tail -f /dev/null

CMD /root/VERGE/src/VERGEd -printtoconsole
