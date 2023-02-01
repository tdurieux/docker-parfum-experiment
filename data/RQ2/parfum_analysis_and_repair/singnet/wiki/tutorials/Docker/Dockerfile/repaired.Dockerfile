FROM ubuntu:18.04

ARG language

ENV SINGNET_REPOS=/opt/singnet
ENV GOPATH=${SINGNET_REPOS}/go
ENV PATH=${GOPATH}/bin:${PATH}

RUN mkdir -p ${GOPATH}

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    apt-utils \
    nano \
    git \
    wget \
    curl \
    zip \
    libudev-dev \
    libusb-1.0-0-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y nodejs npm && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;

RUN cd ${SINGNET_REPOS} && \
    git clone https://github.com/singnet/snet-cli && \
    cd snet-cli && \
    ./scripts/blockchain install && \
    pip3 install --no-cache-dir -e .

RUN cd ${SINGNET_REPOS} && \
    mkdir snet-daemon && \
    cd snet-daemon && \
    wget https://github.com/singnet/snet-daemon/releases/download/v0.1.3/snetd-0.1.3.tar.gz && \
    tar -xvf snetd-0.1.3.tar.gz && \
    mv ./linux-amd64/snetd /usr/bin/snetd && rm snetd-0.1.3.tar.gz

RUN cd ${SINGNET_REPOS} && \
    git clone https://github.com/singnet/wiki.git

RUN if [ "$language" = "cpp" ]; \
    then \
    apt-get install --no-install-recommends -y build-essential autoconf libtool pkg-config libgflags-dev libgtest-dev clang libc++-dev; rm -rf /var/lib/apt/lists/*; \
            git clone -b $( curl -f -L https://grpc.io/release) https://github.com/grpc/grpc; \
            cd grpc; \
            git submodule update --init; \
            make; \
            make install; \
            apt-get install --no-install-recommends -y openjdk-8-jdk; \
            echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list; \
            curl -f https://bazel.build/bazel-release.pub.gpg | apt-key add -; \
            apt-get update; \
            apt-get install --no-install-recommends -y bazel; \
            apt-get upgrade -y bazel; \
            bazel build :all; \
            make install; \
            cd third_party/protobuf; \
            make; \
            make install; \
    fi

RUN if [ "$language" = "go" ]; \
    then \
    apt-get install --no-install-recommends -y golang go-dep golang-goprotobuf-dev golint; rm -rf /var/lib/apt/lists/*; \
            go get -v -u google.golang.org/grpc; \
    fi

RUN if [ "$language" = "java" ]; \
    then \
    apt-get install --no-install-recommends -y unzip openjdk-8-jdk; rm -rf /var/lib/apt/lists/*; \
            curl -f -OL https://github.com/google/protobuf/releases/download/v3.6.1/protoc-3.6.1-linux-x86_64.zip; \
            unzip protoc-3.6.1-linux-x86_64.zip -d protoc3; \
            mv protoc3/bin/* /usr/local/bin/; \
            mv protoc3/include/* /usr/local/include/; \
            rm -rf protoc3; \
            rm protoc-3.6.1-linux-x86_64.zip; \
            curl -f -OL https://central.maven.org/maven2/io/grpc/protoc-gen-grpc-java/1.16.1/protoc-gen-grpc-java-1.16.1-linux-x86_64.exe; \
            mv protoc-gen-grpc-java-1.16.1-linux-x86_64.exe /usr/local/bin/protoc-gen-grpc-java; \
            chmod +x /usr/local/bin/protoc-gen-grpc-java; \
    fi

WORKDIR ${SINGNET_REPOS}
