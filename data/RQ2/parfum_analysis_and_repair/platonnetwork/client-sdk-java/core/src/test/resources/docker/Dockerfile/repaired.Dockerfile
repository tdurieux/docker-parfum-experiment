FROM ubuntu:16.04
WORKDIR /root
RUN set -ex \
    && apt-get update \
    && apt-get -y --no-install-recommends install software-properties-common \
    && add-apt-repository ppa:platonnetwork/platon && rm -rf /var/lib/apt/lists/*;
ADD config .
RUN set -ex \
    && apt-get update \
    && apt-get -y --no-install-recommends install platon \
    && platon --datadir ./data init platon.json && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT ["/usr/bin/platon","--identity","platon","--datadir","./data","--port","16789","--rpcaddr","0.0.0.0","--rpcport","6789","--rpcapi","db,eth,net,web3,admin,personal","--rpc","--nodiscover","--nodekey","./data/platon/nodekey"]
