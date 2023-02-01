FROM debian:9.7

ENV DEBIAN_FRONTEND=noninteractive
ENV GO_VERSION 1.10

RUN apt-get update && \
  apt-get install -y g++ pkg-config ca-certificates unzip wget && \
  apt-get clean && \
  rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd /opt/ && \
    wget -q https://download.pytorch.org/libtorch/cpu/libtorch-shared-with-deps-latest.zip && \
    unzip libtorch-shared-with-deps-latest.zip && \
    rm libtorch-shared-with-deps-latest.zip

RUN echo "$PYTORCH_DIST_DIR/lib" >> /etc/ld.so.conf.d/libtorch.conf && ldconfig
ENV LD_LIBRARY_PATH /opt/libtorch/lib:${LD_LIBRARY_PATH}

RUN  wget -qO- https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz \
    | tar -C /usr/local -xz && \
    export PATH="/usr/local/go/bin:$PATH" && \
    go version; 

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"



