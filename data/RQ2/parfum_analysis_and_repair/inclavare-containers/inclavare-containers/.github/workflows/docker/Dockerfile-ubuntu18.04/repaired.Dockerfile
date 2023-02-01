FROM occlum/occlum:OCCLUM_VERSION-ubuntu18.04

LABEL maintainer="Shirong Hao <shirong@linux.alibaba.com>"

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends libseccomp-dev libprotoc-dev binutils-dev && rm -rf /var/lib/apt/lists/*;

RUN wget https://github.com/protobuf-c/protobuf-c/archive/v1.3.1.tar.gz &&\
    tar -zxvf v1.3.1.tar.gz && cd protobuf-c-1.3.1 &&  ./autogen.sh && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install && \
    apt-get remove -y libprotobuf-dev && apt -y autoremove && rm v1.3.1.tar.gz

# install go
RUN wget https://dl.google.com/go/go1.14.2.linux-amd64.tar.gz && \
    tar -zxvf go1.14.2.linux-amd64.tar.gz -C /usr/lib && rm go1.14.2.linux-amd64.tar.gz

ENV GOROOT          /usr/lib/go
ENV GOPATH          /root/gopath
ENV PATH            $GOROOT/bin:$PATH:$GOPATH/bin
ENV GOPROXY         "https://mirrors.aliyun.com/goproxy,direct"
ENV GO111MODULE     on

WORKDIR /root

# copy binary and configure files
COPY Dockerfile-occlum                                      /root
COPY Dockerfile-skeleton                                    /root
COPY hello_world.c                                          /root

# install docker-ce
RUN apt-get install --no-install-recommends -y apt-transport-https ca-certificates curl software-properties-common && \
    curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository 'deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu bionic stable' && \
    apt-get update && apt-get install --no-install-recommends -y docker-ce && rm -rf /var/lib/apt/lists/*;


# configure docker
RUN mkdir -p /etc/docker && \
    echo "{\n\t\"runtimes\": {\n\t\t\"rune\": {\n\t\t\t\"path\": \"/usr/local/bin/rune\",\n\t\t\t\"runtimeArgs\": []\n\t\t}\n\t},\n\t\"storage-driver\": \"vfs\"\n}" >> /etc/docker/daemon.json
