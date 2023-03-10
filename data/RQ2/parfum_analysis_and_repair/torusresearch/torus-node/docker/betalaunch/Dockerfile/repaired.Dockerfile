FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y wget && apt-get install --no-install-recommends -y git && apt-get install --no-install-recommends -y make && apt-get install --no-install-recommends -y build-essential && \
    echo "Ubuntu is ready!" && \
    # sed "s/mesg n || true/test -t 0 \&\& mesg n/" $HOME/.profile && \
    wget https://dl.google.com/go/go1.11.2.linux-amd64.tar.gz && tar -C /usr/local -xzf go1.11.2.linux-amd64.tar.gz && \
    echo "export PATH=$PATH:/usr/local/go/bin" >> $HOME/.profile && echo "export GOPATH=$HOME/go" >> $HOME/.profile && rm go1.11.2.linux-amd64.tar.gz && . $HOME/.profile && \
    echo "Go Installed!" && \
    mkdir $GOPATH && mkdir $GOPATH/src && mkdir $GOPATH/src/github.com && mkdir $GOPATH/src/github.com/torusresearch && mkdir $GOPATH/bin && \
    cd $GOPATH/src/github.com/torusresearch && git clone https://github.com/torusresearch/torus && mkdir $GOPATH/src/github.com/tendermint && cd $GOPATH/src/github.com/tendermint && \
    echo "Standard files cloned!" && \
    echo "export PATH=$PATH:$GOPATH/bin" >> $HOME/.profile && . $HOME/.profile && \
    # wget https://raw.githubusercontent.com/golang/dep/master/install.sh && chmod +x ./install.sh && ./install.sh && \
    git clone https://github.com/YZhenY/tendermint && cd $GOPATH/src/github.com/torusresearch/tendermint && \
    make get_tools && make get_vendor_deps && \
    echo "Dependencies Built!" && \
    apt-get install --no-install-recommends -y libsnappy-dev && \
    wget https://github.com/google/leveldb/archive/v1.20.tar.gz && \
    tar -zxvf v1.20.tar.gz && \
    cd leveldb-1.20/ && \
    make && \
    cp -r out-static/lib* out-shared/lib* /usr/local/lib/ && \
    cd include/ && \
    cp -r leveldb /usr/local/include/ && \
    ldconfig && \
    echo "Built CLevelDB!" && \
    rm -f v1.20.tar.gz && cd $GOPATH/src/github.com/torusresearch/torus-node/cmd/dkgnode && go install && cd $HOME && echo "export PATH=$PATH" >> ~/.bashrc && \
    mkdir /.build && mkdir /root/https && rm -rf /var/lib/apt/lists/*;

EXPOSE 443 80 26656 26657
VOLUME ["/.build", "/root/https"]
CMD /root/go/bin/dkgnode -privateKey ${PRIVATEKEY} -ipAddress ${IPADDRESS} -nodeListAddress ${NODELISTADDRESS}