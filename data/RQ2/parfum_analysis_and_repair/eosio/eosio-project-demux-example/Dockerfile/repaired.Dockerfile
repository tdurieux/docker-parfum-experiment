FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install --no-install-recommends -y wget sudo curl && rm -rf /var/lib/apt/lists/*;
RUN wget https://github.com/EOSIO/eosio.cdt/releases/download/v1.5.0/eosio.cdt_1.5.0-1_amd64.deb
RUN sudo apt install --no-install-recommends -y ./eosio.cdt_1.5.0-1_amd64.deb && rm -rf /var/lib/apt/lists/*;
RUN wget https://github.com/EOSIO/eos/releases/download/v1.6.0/eosio_1.6.0-1-ubuntu-18.04_amd64.deb
RUN sudo apt install --no-install-recommends -y ./eosio_1.6.0-1-ubuntu-18.04_amd64.deb && rm -rf /var/lib/apt/lists/*;
