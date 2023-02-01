FROM node:10

WORKDIR /home

ENV DOCKER true

ENV GOCACHE=/home/.go-build
ENV GO111MODULE=on
ENV GOROOT=/usr/local/go
ENV GOPATH=/home/go

RUN apt-get update && apt-get install --no-install-recommends -y netcat build-essential libudev-dev jq && rm -rf /var/lib/apt/lists/*;

RUN wget -q --show-progress --progress=bar:force https://dl.google.com/go/go1.13.linux-amd64.tar.gz
RUN tar -xf go1.13.linux-amd64.tar.gz --totals && rm go1.13.linux-amd64.tar.gz
RUN mv go /usr/local
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH
RUN go version
RUN GO111MODULE=off go get -u github.com/go-bindata/go-bindata/...

RUN git clone -b release/1.8 https://github.com/ethereum/go-ethereum /home/go/src/github.com/ethereum/go-ethereum
RUN cd /home/go/src/github.com/ethereum/go-ethereum && GO111MODULE=off make devtools
RUN rm -rf /home/go/src/github.com/ethereum/go-ethereum

RUN yarn global add npm npx ganache-cli typescript prettier npm-cli-login

CMD [ "node" ]
