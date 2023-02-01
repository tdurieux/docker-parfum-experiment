FROM ubuntu:20.04
LABEL mantainer="Vincenzo Palazzo vincenzopalazzodev@gmail.com"

ENV TZ=Europe/Minsk
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Ubuntu utils
RUN apt-get update && apt-get install --no-install-recommends -y \
    software-properties-common \
    build-essential \
    curl && rm -rf /var/lib/apt/lists/*;

RUN apt-get update

## Install Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install bitcoin core and lightningd (last version)
RUN add-apt-repository ppa:luke-jr/bitcoincore
RUN apt-get update && apt-get install --no-install-recommends -y bitcoind jq && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -u ppa:lightningnetwork/ppa
RUN apt-get update && apt-get install --no-install-recommends -y lightningd && rm -rf /var/lib/apt/lists/*;

WORKDIR workdir
COPY sandbox .
COPY . /workdir/code

CMD ["./entrypoint.sh"]