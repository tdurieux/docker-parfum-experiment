FROM ubuntu:20.04

USER root

RUN apt-get update && apt-get upgrade -y

RUN apt install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;

# utils
RUN apt install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

# golang
RUN wget https://dl.google.com/go/go1.13.8.linux-amd64.tar.gz && \
  tar -xzvf go1.13.8.linux-amd64.tar.gz -C /usr/local && \
  export PATH=$PATH:/usr/local/go/bin && echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc && \
  mkdir $HOME/go && rm go1.13.8.linux-amd64.tar.gz

ENV PATH="${PATH}:/usr/local/go/bin"

# deployment scripts deps: needed only if configuration checks are enabled
RUN python3 -m pip install pymultihash ecdsa base58

WORKDIR /acn/

# get node source code
COPY ./packages/fetchai/connections/p2p_libp2p/libp2p_node /acn/node

# get deployment script
COPY ./scripts/acn/run_acn_node_standalone.py /acn/

# build node
RUN cd /acn/node && go build

EXPOSE 9000
EXPOSE 11000
EXPOSE 8080

ENTRYPOINT [ "python3", "-u", "/acn/run_acn_node_standalone.py", "/acn/node/libp2p_node"]

