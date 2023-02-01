FROM ubuntu:20.04
LABEL mantainer="Vincenzo Palazzo vincenzopalazzodev@gmail.com"

# Ubuntu utils
RUN apt-get update && apt-get install --no-install-recommends -y \
   software-properties-common && rm -rf /var/lib/apt/lists/*;

## Install jdk 11
RUN add-apt-repository -y ppa:linuxuprising/java
RUN apt-get update && apt-get install --no-install-recommends openjdk-11-jdk wget libsodium-dev libpq-dev -y && rm -rf /var/lib/apt/lists/*;

# Install bitcoin core and lightningd (last version)
RUN add-apt-repository ppa:luke-jr/bitcoincore
RUN apt-get update && apt-get install --no-install-recommends -y bitcoind jq && rm -rf /var/lib/apt/lists/*;
#RUN add-apt-repository -u ppa:lightningnetwork/ppa
#RUN apt-get update  && apt-get install -y lightningd

ENV CLIGHTNING_VERSION=0.10.1

RUN wget https://github.com/ElementsProject/lightning/releases/download/v$CLIGHTNING_VERSION/clightning-v$CLIGHTNING_VERSION-Ubuntu-20.04.tar.xz && \
    tar -xvf clightning-v$CLIGHTNING_VERSION-Ubuntu-20.04.tar.xz -C /opt && cd /opt && \
    mv usr clightning-v$CLIGHTNING_VERSION && rm clightning-v$CLIGHTNING_VERSION-Ubuntu-20.04.tar.xz

RUN rm -r clightning-v$CLIGHTNING_VERSION-Ubuntu-20.04.tar.xz

ENV PATH=/opt/clightning-v$CLIGHTNING_VERSION/bin:$PATH

WORKDIR workdir

CMD ["./entrypoint.sh"]