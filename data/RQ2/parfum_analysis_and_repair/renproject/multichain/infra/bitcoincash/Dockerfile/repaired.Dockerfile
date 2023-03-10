FROM ubuntu:bionic

# Install bitcoind-abc.
RUN apt-get update && apt-get install --no-install-recommends --yes software-properties-common && \
add-apt-repository ppa:ubuntu-toolchain-r/test && apt-get update && \
 apt-get install --no-install-recommends --yes g++-7 && \
add-apt-repository ppa:bitcoin-cash-node/ppa && apt-get update && \
 apt-get install --no-install-recommends --yes bitcoind && rm -rf /var/lib/apt/lists/*;

COPY bitcoin.conf /root/.bitcoin/
COPY run.sh /root/
RUN chmod +x /root/run.sh

EXPOSE 19443

ENTRYPOINT ["./root/run.sh"]
