FROM cassandra:3.11

RUN apt-get update \
     && apt-get -qq --no-install-recommends -y install libcap2-bin \
     && setcap cap_ipc_lock=ep $(readlink -f $(which java)) && rm -rf /var/lib/apt/lists/*;
