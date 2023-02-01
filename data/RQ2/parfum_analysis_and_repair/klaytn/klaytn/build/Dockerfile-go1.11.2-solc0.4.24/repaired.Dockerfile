FROM ubuntu:18.04
USER root
RUN apt update
RUN apt install --no-install-recommends -y git lsb-core sudo && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libboost-all-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y build-essential cmake && rm -rf /var/lib/apt/lists/*;
WORKDIR /root
RUN git clone --recursive https://github.com/ethereum/solidity.git
WORKDIR /root/solidity
RUN git checkout v0.4.24
RUN ./scripts/build.sh
RUN mkdir /root/golang-1.11.2
WORKDIR /root/golang-1.11.2
RUN curl -f -O https://storage.googleapis.com/golang/go1.11.2.linux-amd64.tar.gz
RUN tar -xvzf go1.11.2.linux-amd64.tar.gz && rm go1.11.2.linux-amd64.tar.gz
RUN mv go /usr/local
RUN ln -s /usr/local/go/bin/go /usr/bin/
RUN ln -s /usr/local/go/bin/gofmt /usr/bin/
RUN ln -s /usr/local/go/bin/godoc /usr/bin/

