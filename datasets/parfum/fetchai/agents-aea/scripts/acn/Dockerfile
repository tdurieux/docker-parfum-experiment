FROM ubuntu:20.04

USER root

RUN apt-get update && apt-get upgrade -y

RUN apt install -y python3 python3-pip

# utils
RUN apt install -y wget subversion

# golang
RUN wget https://dl.google.com/go/go1.13.8.linux-amd64.tar.gz && \
  tar -xzvf go1.13.8.linux-amd64.tar.gz -C /usr/local && \
  export PATH=$PATH:/usr/local/go/bin && echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc && \
  mkdir $HOME/go

ENV PATH="${PATH}:/usr/local/go/bin"

# deployment scripts deps: needed only if configuration checks are enabled
RUN python3 -m pip install pymultihash ecdsa base58

WORKDIR /acn/

# get node source code
RUN svn export https://github.com/fetchai/agents-aea/trunk/packages/fetchai/connections/p2p_libp2p/libp2p_node/ /acn/node

# get deployment script
RUN svn export https://github.com/fetchai/agents-aea/trunk/scripts/acn/run_acn_node_standalone.py /acn/

# build node
RUN cd /acn/node && go build

EXPOSE 9000
EXPOSE 11000
EXPOSE 8080

ENTRYPOINT [ "python3", "-u", "/acn/run_acn_node_standalone.py", "/acn/node/libp2p_node"]

