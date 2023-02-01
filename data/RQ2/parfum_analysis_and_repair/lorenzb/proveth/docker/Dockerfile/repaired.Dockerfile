FROM ubuntu:bionic

# House keeping
RUN apt-get update

# Python 3.6 and pip dependencies
RUN apt-get -y --no-install-recommends install apt-utils python3.6 python3.6-dev python3-pip git gcc && apt-get -y --no-install-recommends install pkg-config libffi6 autoconf automake libtool openssl libssl-dev && rm -rf /var/lib/apt/lists/*;

# Solidity
RUN apt-get -y --no-install-recommends install software-properties-common && add-apt-repository -y ppa:ethereum/ethereum && apt-get update && apt-get -y --no-install-recommends install solc && rm -rf /var/lib/apt/lists/*;

