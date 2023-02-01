FROM nvidia/cuda:9.0-devel-ubuntu16.04


RUN apt-get update && apt-get install --no-install-recommends -yy \
    wget \
    libtool-bin \
    autoconf \
    g++ \
    git \
    make \
    golang-go && rm -rf /var/lib/apt/lists/*;


RUN mkdir /zmq
RUN wget https://files.patwie.com/mirror/zeromq-4.1.0-rc1.tar.gz
RUN tar -xf zeromq-4.1.0-rc1.tar.gz -C /zmq && rm zeromq-4.1.0-rc1.tar.gz
WORKDIR /zmq/zeromq-4.1.0
RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/zmq/zeromq-4.1.0/dist
RUN make
RUN make install


ENV PKG_CONFIG_PATH="/zmq/zeromq-4.1.0/dist/lib/pkgconfig:${PKG_CONFIG_PATH}"
ENV LD_LIBRARY_PATH="/zmq/zeromq-4.1.0/dist/lib:${LD_LIBRARY_PATH}"
ENV GOPATH="/gocode"
RUN mkdir -p /gocode/src/github.com/patwie/cluster-smi
ENV CLUSTER_SMI_CONFIG_PATH="/cluster-smi.yml"


