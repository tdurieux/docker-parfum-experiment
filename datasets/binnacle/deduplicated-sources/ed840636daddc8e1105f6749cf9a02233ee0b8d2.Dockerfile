FROM ubuntu_18_04-base
MAINTAINER Wander Lairson Costa <wcosta@mozilla.com>
LABEL Description="docker-worker packet.net image" Vendor="Mozilla"

# BEGIN BASE IMAGE

ENV DEBIAN_FRONTEND noninteractive

ENV PAPERTRAIL logs.papertrailapp.com:52806

RUN echo $(which nologin) >> /etc/shells
RUN useradd -m -s $(which nologin) ubuntu
RUN usermod -L ubuntu

COPY ./deploy/packer/base/scripts/configure_syslog.sh /tmp/
COPY ./deploy/packer/base/scripts/node.sh /tmp/
COPY ./deploy/fake-keys/docker-worker-ed25519-cot-signing-key.key /etc/

RUN chmod +x /tmp/configure_syslog.sh /tmp/node.sh

RUN /tmp/configure_syslog.sh

RUN groupadd -f docker

RUN apt-get update
RUN apt-get install -yq \
	curl \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
	&& apt-key fingerprint 0EBFCD88 \
	&& add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable" \
	&& apt-get update

RUN apt-get install -yq \
    unattended-upgrades \
    docker-ce=18.06.0~ce~3-0~ubuntu \
    lvm2 \
    build-essential \
    git-core \
    gstreamer1.0-alsa \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-tools \
    pbuilder \
    python-mock \
    python-configobj \
	dh-python \
    cdbs \
    python-pip \
    jq \
    rsyslog-gnutls \
    openvpn \
    rng-tools \
    liblz4-tool \
	linux-image-generic \
	linux-headers-generic \
	dkms

RUN apt-get purge -yq apport

RUN git clone git://github.com/facebook/zstd /tmp/zstd \
	&& cd /tmp/zstd \
	&& git checkout f3a8bd553a865c59f1bd6e1f68bf182cf75a8f00 \
	&& make zstd \
	&& mv zstd /usr/bin

RUN cd /lib/modules \
	&& KERNEL_VER=$(ls -1 | tail -1) \
	&& V4L2LOOPBACK_VERSION=0.12.0 \
	&& cd /usr/src \
	&& git clone --branch v${V4L2LOOPBACK_VERSION} git://github.com/umlaeute/v4l2loopback.git v4l2loopback-${V4L2LOOPBACK_VERSION} \
	&& cd v4l2loopback-${V4L2LOOPBACK_VERSION} \
	&& dkms install -m v4l2loopback -v ${V4L2LOOPBACK_VERSION} -k ${KERNEL_VER} \
	&& dkms build -m v4l2loopback -v ${V4L2LOOPBACK_VERSION} -k ${KERNEL_VER}

RUN echo "v4l2loopback" | tee --append /etc/modules
RUN echo "options v4l2loopback devices=100" > /etc/modprobe.d/v4l2loopback.conf
RUN echo "snd-aloop" | tee --append /etc/modules
RUN echo "options snd-aloop enable=1,1,1,1,1,1,1,1 index=0,1,2,3,4,5,6,7" > /etc/modprobe.d/snd-aloop.conf

RUN echo "#!/bin/sh -e" > /etc/rc.local
RUN echo "modprobe snd-aloop" >> /etc/rc.local
RUN echo "exit 0" >> /etc/rc.local
RUN chmod +x /etc/rc.local

RUN echo net.ipv4.tcp_challenge_ack_limit = 999999999 >> /etc/sysctl.conf

RUN apt-get autoremove -y
RUN unattended-upgrade

RUN /tmp/node.sh

# END BASE IMAGE

# BEGIN APP IMAGE

COPY deploy/deploy.tar.gz /tmp
COPY docker-worker.tgz /tmp

RUN curl -o /etc/papertrail-bundle.pem https://papertrailapp.com/tools/papertrail-bundle.pem
# RUN test `md5sum /etc/papertrail-bundle.pem | awk '{ print $1 }'` == "2c43548519379c083d60dd9e84a1b724"

RUN apt-get install -y python-statsd

RUN tar xzf /tmp/deploy.tar.gz -C / --strip-components=1

RUN mkdir -p /home/ubuntu/docker_worker
RUN npm i -g yarn
RUN cd /home/ubuntu/docker_worker && tar xzf /tmp/docker-worker.tgz -C . && yarn install --frozen-lockfile

COPY ./deploy/packet-net/docker-worker.service /lib/systemd/system/docker-worker.service
RUN systemctl enable docker-worker

# END OF APP IMAGE
