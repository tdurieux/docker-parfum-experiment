FROM ubuntu:19.10

ARG BNC_VERSION=0.6.2

RUN apt-get update && \
    apt-get install --no-install-recommends -y git git-lfs && rm -rf /var/lib/apt/lists/*;

WORKDIR /binaries

RUN GIT_LFS_SKIP_SMUDGE=1 git clone --depth 1 https://github.com/binance-chain/node-binary.git .

RUN git lfs pull -I fullnode/testnet/${BNC_VERSION}/linux
RUN git lfs pull -I cli/testnet/${BNC_VERSION}/linux

RUN ./fullnode/testnet/${BNC_VERSION}/linux/bnbchaind testnet --acc-prefix tbnb --chain-id Binance-Dev --v 1

RUN sed -i "s/publishTransfer = false/publishTransfer = true/" ./mytestnet/node0/gaiad/config/app.toml && \
    sed -i "s/publishLocal = false/publishLocal = true/" ./mytestnet/node0/gaiad/config/app.toml && \
    sed -i "s/BEP12Height = 9223372036854775807/BEP12Height = 1/" ./mytestnet/node0/gaiad/config/app.toml
