FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get -y install --no-install-recommends git fuse \
            # blobfuse dependencies \
	    pkg-config libfuse-dev cmake libcurl4-gnutls-dev libgnutls28-dev uuid-dev \
	    libgcrypt20-dev libboost-all-dev gcc g++ \
            # for running goofys benchmark \
            curl python-setuptools python-pip gnuplot-nox imagemagick \
            # finally, clean up to make image smaller \
            && apt-get clean && rm -rf /var/lib/apt/lists/*;
# goofys graph generation
RUN pip install --no-cache-dir numpy

WORKDIR /tmp

ENV PATH=$PATH:/usr/local/go/bin
ARG GOVER=1.12.6
RUN curl -f -O https://storage.googleapis.com/golang/go${GOVER}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go${GOVER}.linux-amd64.tar.gz && \
    rm go${GOVER}.linux-amd64.tar.gz

ARG MAKEFLAGS=-j8
RUN git clone --depth 1 https://github.com/Azure/azure-storage-fuse.git && \
    cd azure-storage-fuse && bash ./build.sh > /dev/null && make -C build install && \
    cd .. && rm -Rf azure-storage-fuse

# ideally I want to clear out all the go deps too but there's no
# way to do that with ADD
ENV PATH=$PATH:/root/go/bin
ADD . /root/go/src/github.com/yandex-cloud/geesefs
WORKDIR /root/go/src/github.com/yandex-cloud/geesefs
RUN go get . && make install

ENTRYPOINT ["/root/go/src/github.com/yandex-cloud/geesefs/bench/run_bench.sh"]
