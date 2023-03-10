FROM ubuntu:18.04

ARG VERSION
ENV VERSION=${VERSION}

RUN apt-get -y update
RUN apt-get -y --no-install-recommends install apt-utils apt-transport-https ca-certificates curl software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get -y update

CMD mkdir -p /packages/archives && \
    apt-get -d -y install \
    containerd.io=$(apt-cache madison 'containerd.io' | grep ${VERSION} | head -1 | awk '{$1=$1};1' | cut -d' ' -f 3) \
    -oDebug::NoLocking=1 -o=dir::cache=/packages/ && \
    cp -r /packages/archives/* /out/
