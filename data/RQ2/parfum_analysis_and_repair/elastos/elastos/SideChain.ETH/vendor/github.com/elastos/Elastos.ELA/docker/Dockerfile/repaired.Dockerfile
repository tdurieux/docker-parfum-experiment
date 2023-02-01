FROM ubuntu:16.04

# Install necessary tools
RUN apt-get update && apt-get install --no-install-recommends -y git curl && rm -rf /var/lib/apt/lists/*;

# Install golang
RUN apt-get install --no-install-recommends -y software-properties-common && add-apt-repository -y ppa:gophers/archive && apt-get update && apt-get install --no-install-recommends -y golang-1.9-go && rm -rf /var/lib/apt/lists/*;

# Prepare environment
RUN mkdir /root/dev/bin -p && mkdir /root/dev/src/github.com/elastos -p

WORKDIR /root/dev/

# Install glide
RUN export GOROOT=/usr/lib/go-1.9  GOPATH=$HOME/dev && export GOBIN=$GOPATH/bin PATH=$GOROOT/bin:$PATH && export PATH=$GOBIN:$PATH && curl -f https://glide.sh/get | sh

WORKDIR /root/dev/src/github.com/elastos
# Clone source code
RUN git clone https://github.com/elastos/Elastos.ELA.git

WORKDIR Elastos.ELA

# Build Elastos.ELA Node
RUN export GOROOT=/usr/lib/go-1.9  GOPATH=$HOME/dev && export GOBIN=$GOPATH/bin PATH=$GOROOT/bin:$PATH && export PATH=$GOBIN:$PATH && glide update && glide install && make && mv config.json.sample config.json

ENTRYPOINT ["./ela"]

EXPOSE 20334 20335 20336 20338