# Quick usage instructions:
# > sudo docker build -t pwdock .
# > sudo docker run -it pwdock bash
# root@xxxxxxxxxxxx:pw# ./run_pw
FROM ubuntu:bionic

# install all known dependencies
RUN apt-get update \
&& apt-get upgrade -y \
&& apt-get install --no-install-recommends -y vim git build-essential python3.6-dev python3.6 python3-pip libpcap-dev graphviz python3-pyroute2 python3-scapy libgmp3-dev && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir sphinx pylint sphinx_rtd_theme pcapy gmpy pyroute2

# add packetweaver source code
WORKDIR /pw
ADD . .

# build documentation
WORKDIR packetweaver/doc
RUN make all

# go back to the "run_pw" directory
WORKDIR ../..

