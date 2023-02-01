FROM ubuntu:21.10

# wget https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v4.38-9760-rtm/softether-vpnserver-v4.38-9760-rtm-2021.08.17-linux-x64-64bit.tar.gz
# sha256: 4221e61a19392ed240cefd087005187398fdb7e2325c08565fccab68ad27f0ac
ADD softether-vpnserver-v4.38-9760-rtm-2021.08.17-linux-x64-64bit.tar.gz /opt/softether/

RUN apt-get update && apt-get -y --no-install-recommends install make gcc openssl unzip goxkcdpwgen && rm -rf /var/lib/apt/lists/*;

# debugging
#RUN apt-get -y install iproute2 vim less

WORKDIR /opt/softether/vpnserver
RUN make
COPY launch /
CMD /launch
