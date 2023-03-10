FROM debian
RUN apt-get update
RUN apt-get -y --no-install-recommends install gcc-multilib g++-multilib && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install gcc-arm-none-eabi python3-pil build-essential clang wget curl git unzip llvm-7 gcc-8-arm-linux-gnueabi jq && rm -rf /var/lib/apt/lists/*;
RUN mkdir /sdk && cd /sdk && git clone https://github.com/LedgerHQ/nanos-secure-sdk && cd nanos-secure-sdk && git checkout nanos-161
ENV BOLOS_SDK=/sdk/nanos-secure-sdk
RUN mkdir -p /apps /apps-out
WORKDIR /apps

RUN git clone https://github.com/ledgerhq/app-bitcoin
RUN cd /apps/app-bitcoin && git checkout 1.5.5 && make -j8 bin/app.elf && cp bin/app.elf /apps-out/btc.elf

RUN git clone https://github.com/ledgerhq/app-ethereum
RUN cd /apps/app-ethereum && git checkout 1.6.4 && make -j8 bin/app.elf && cp bin/app.elf /apps-out/eth.elf

RUN git clone https://github.com/ledgerhq/app-xrp
RUN cd /apps/app-xrp && git checkout 2.2.0 && make -j8 bin/app.elf && cp bin/app.elf /apps-out/xrp.elf

RUN git clone https://github.com/ledgerhq/app-stellar
RUN cd /apps/app-stellar && git checkout 3.3.0 && make -j8 bin/app.elf && cp bin/app.elf /apps-out/xlm.elf

RUN cd /apps/app-bitcoin && git checkout 1.5.5 && git clean -dfx && COIN=litecoin make -j8 bin/app.elf && cp bin/app.elf /apps-out/ltc.elf

RUN git clone https://github.com/ledgerhq/app-tezos
# COMMIT=76ffcd4c
RUN cd /apps/app-tezos && git checkout unifiy-ux && make -j8 bin/app.elf && cp bin/app.elf /apps-out/xtz.elf

# This is only for the future.
# ADA is currently not supported by ledger live.
# If we figure out how to use the emulator protocol to get an address, then we can maybe use this...
RUN git clone https://github.com/ledgerhq/app-cardano
RUN cd /apps/app-cardano && git checkout 2.2.0 && make -j8 bin/app.elf && cp bin/app.elf /apps-out/ada.elf
