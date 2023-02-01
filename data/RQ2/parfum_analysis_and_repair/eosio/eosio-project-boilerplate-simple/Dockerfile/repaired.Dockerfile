FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y wget sudo curl && rm -rf /var/lib/apt/lists/*;
RUN wget https://github.com/EOSIO/eosio.cdt/releases/download/v1.6.2/eosio.cdt_1.6.2-1-ubuntu-18.04_amd64.deb
RUN apt-get update && sudo apt install --no-install-recommends -y ./eosio.cdt_1.6.2-1-ubuntu-18.04_amd64.deb && rm -rf /var/lib/apt/lists/*;
RUN wget https://github.com/EOSIO/eos/releases/download/v2.0.5/eosio_2.0.5-1-ubuntu-18.04_amd64.deb
RUN apt-get update && sudo apt install --no-install-recommends -y ./eosio_2.0.5-1-ubuntu-18.04_amd64.deb && rm -rf /var/lib/apt/lists/*;
