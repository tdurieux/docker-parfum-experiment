FROM ubuntu:18.04 AS builder

LABEL maintainer="Shirong Hao <shirong@linux.alibaba.com>"

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y \
    make git vim clang-format-9 gcc pkg-config protobuf-compiler debhelper cmake \
    wget net-tools curl file gnupg tree \
    libbinutils \
    libseccomp-dev libssl-dev binutils-dev libprotoc-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /root

RUN mkdir /root/gopath

# build and install prortobuf-c
RUN wget https://github.com/protobuf-c/protobuf-c/archive/v1.3.1.tar.gz && \
    tar -zxvf v1.3.1.tar.gz && cd protobuf-c-1.3.1 && ./autogen.sh && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install && rm -f ../v1.3.1.tar.gz

# install golang
RUN wget https://dl.google.com/go/go1.14.2.linux-amd64.tar.gz && \
    tar -zxvf go1.14.2.linux-amd64.tar.gz -C /usr/lib && \
    rm -f go1.14.2.linux-amd64.tar.gz

# configure GOPATH and GOROOT
ENV GOROOT       /usr/lib/go
ENV GOPATH       /root/gopath
ENV PATH         $PATH:$GOROOT/bin:$GOPATH/bin
ENV GO111MODULE  on

# install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
ENV PATH         /root/.cargo/bin:$PATH

FROM builder AS eaa

# download and install containerd 1.5.3
RUN wget https://github.com/containerd/containerd/releases/download/v1.5.3/cri-containerd-cni-1.5.3-linux-amd64.tar.gz && \
    tar zxvf cri-containerd-cni-1.5.3-linux-amd64.tar.gz && \
    cp -rf etc/* /etc/ && cp -rf opt/* /opt/ && \
    cp -f usr/local/bin/* /usr/local/bin/ && \
    rm -rf cri-containerd-cni-1.5.3-linux-amd64.tar.gz etc opt usr

# configue ocicrypt keyprovider
RUN mkdir -p /etc/containerd/ocicrypt/keys

# configure containerd
RUN containerd config default > config.toml && \
    sed -i "s#k8s.gcr.io/pause:3.5#registry.cn-hangzhou.aliyuncs.com/acs/pause-amd64:3.1#g" config.toml && \
    sed -i 's/\(snapshotter = \)"overlayfs"/\1"native"/' config.toml && \
    cp -f config.toml /etc/containerd

# build and install skopeo
RUN git clone https://github.com/containers/skopeo $GOPATH/src/github.com/containers/skopeo && \
    apt-get install --no-install-recommends -y libdevmapper-dev build-essential nghttp2 libnghttp2-dev libssl-dev libfftw3-dev libsndfile1-dev libgpgme-dev && \
    cd $GOPATH/src/github.com/containers/skopeo && make bin/skopeo && \
    cp -f $GOPATH/src/github.com/containers/skopeo/bin/skopeo /usr/local/bin/ && rm -rf /var/lib/apt/lists/*;

# configue crictl
RUN echo "runtime-endpoint: unix:///run/containerd/containerd.sock\nimage-endpoint: unix:///run/containerd/containerd.sock\ntimeout: 2\ndebug: true" > /etc/crictl.yaml

FROM builder

ENV SGX_SDK_VERSION         2.14
ENV SGX_SDK_RELEASE_NUMBER  2.14.100.2

# install LVI binutils for rats-tls build
RUN wget https://download.01.org/intel-sgx/sgx-linux/$SGX_SDK_VERSION/as.ld.objdump.gold.r3.tar.gz && \
     tar -zxvf as.ld.objdump.gold.r3.tar.gz && cp -rf external/toolset/ubuntu18.04/* /usr/local/bin/ && \
     rm -rf external && rm -rf as.ld.objdump.gold.r3.tar.gz

# install docker
RUN apt-get install --no-install-recommends -y iptables && \
    wget https://download.docker.com/linux/static/stable/x86_64/docker-18.09.7.tgz && \
    tar -zxvf docker-18.09.7.tgz && mv docker/* /usr/bin && rm -rf docker && rm -f docker-18.09.7.tgz && rm -rf /var/lib/apt/lists/*;

# configure the rune runtime of docker
RUN mkdir -p /etc/docker && \
    echo "{\n\t\"runtimes\": {\n\t\t\"rune\": {\n\t\t\t\"path\": \"/usr/local/bin/rune\",\n\t\t\t\"runtimeArgs\": []\n\t\t}\n\t}\n}" >> /etc/docker/daemon.json

# install Intel SGX SDK and DCAP
RUN [ ! -f sgx_linux_x64_sdk_$SGX_SDK_RELEASE_NUMBER.bin ] && \
    wget https://download.01.org/intel-sgx/sgx-linux/$SGX_SDK_VERSION/distro/ubuntu18.04-server/sgx_linux_x64_sdk_$SGX_SDK_RELEASE_NUMBER.bin && \
    chmod +x sgx_linux_x64_sdk_$SGX_SDK_RELEASE_NUMBER.bin && echo -e 'no\n/opt/intel\n' | ./sgx_linux_x64_sdk_$SGX_SDK_RELEASE_NUMBER.bin && \
    rm -f sgx_linux_x64_sdk_$SGX_SDK_RELEASE_NUMBER.bin

RUN echo "deb [arch=amd64] https://download.01.org/intel-sgx/sgx_repo/ubuntu bionic main" | tee /etc/apt/sources.list.d/intel-sgx.list && \
    wget -qO - https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key | apt-key add -

RUN apt-get update -y && apt-get install --no-install-recommends -y \
    libsgx-uae-service libsgx-dcap-default-qpl \
    libsgx-dcap-quote-verify-dev libsgx-dcap-ql-dev && rm -rf /var/lib/apt/lists/*;

# install the packages need by skopeo
RUN apt-get install --no-install-recommends -y libdevmapper-dev libgpgme-dev && rm -rf /var/lib/apt/lists/*;

# install OPA go dependencies
RUN go get github.com/open-policy-agent/opa@v0.30.2
RUN curl -f -L -o opa https://openpolicyagent.org/downloads/v0.30.2/opa_linux_amd64_static
RUN chmod 755 ./opa && mv opa /usr/local/bin/

# copy binary and configure files
COPY --from=eaa /opt/cni                             /opt/cni
COPY --from=eaa /etc/containerd                      /etc/containerd
COPY --from=eaa /etc/cni                             /etc/cni
COPY --from=eaa /etc/crictl.yaml                     /etc
COPY --from=eaa /usr/local/bin                       /usr/local/bin
