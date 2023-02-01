FROM ubuntu:xenial
RUN apt-get update && apt-get install --no-install-recommends -y jq curl software-properties-common \
    && add-apt-repository ppa:bitcoin-unlimited/bu-ppa \
    && apt-get update && apt-get install --no-install-recommends -y bitcoind && rm -rf /var/lib/apt/lists/*;
#
ADD bitcoin.conf /root/.bitcoin/
ADD start.sh /
RUN chmod +x /start.sh
EXPOSE 18332 18333
