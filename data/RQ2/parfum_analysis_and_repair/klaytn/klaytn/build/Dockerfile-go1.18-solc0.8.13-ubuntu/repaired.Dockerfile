FROM ubuntu:20.04 as solc_0.8.13_builder
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Seoul
RUN apt update
RUN apt install --no-install-recommends -yq tzdata && \
    ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y git lsb-core sudo libboost-all-dev build-essential cmake z3 && rm -rf /var/lib/apt/lists/*;
RUN git clone --depth 1 --recursive -b v0.8.13 https://github.com/ethereum/solidity
RUN cd /solidity && cmake -DCMAKE_BUILD_TYPE=Release -DTESTS=0 -DSTATIC_LINKING=1
RUN cd /solidity && touch prerelease.txt
RUN cd /solidity && make solc
RUN cd /solidity && install -s solc/solc /usr/bin

FROM ubuntu:20.04 as go_builder
RUN apt update
RUN apt install --no-install-recommends -yq tzdata && \
    ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y build-essential bash gcc musl-dev openssl wget golang-go && rm -rf /var/lib/apt/lists/*;
RUN wget -O go.src.tar.gz https://dl.google.com/go/go1.18.src.tar.gz
RUN tar -C /usr/local -xzf go.src.tar.gz && rm go.src.tar.gz
RUN cd /usr/local/go/src/ && \
    ./make.bash

FROM ubuntu:20.04
RUN apt update
RUN apt install --no-install-recommends -yq tzdata && \
    ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y ca-certificates libboost-all-dev git make gcc libc-dev curl bash python3 python3-dev python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir awscli
COPY --from=solc_0.8.13_builder /usr/bin/solc /usr/bin/solc
COPY --from=go_builder /usr/local/go /usr/local

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.24.0