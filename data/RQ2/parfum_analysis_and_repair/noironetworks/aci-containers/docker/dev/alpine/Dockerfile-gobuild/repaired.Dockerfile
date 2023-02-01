FROM golang
ARG proxy
ENV https_proxy=$proxy
ENV http_proxy=$proxy
RUN curl -f https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

RUN apt-get update
RUN apt-get install --no-install-recommends -y python3 python3-pip && pip3 install --no-cache-dir -U pytest && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -U kubernetes

RUN apt-get -y --no-install-recommends install git unzip build-essential autoconf libtool && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/google/protobuf.git && \
    cd protobuf && \
    ./autogen.sh && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make && \
    make install && \
    ldconfig && \
    make clean && \
    cd .. && \
    rm -r protobuf

# Get the source from GitHub
RUN go get google.golang.org/grpc
# Install protoc-gen-go
RUN go get github.com/golang/protobuf/protoc-gen-go

ENV https_proxy=
ENV http_proxy=
