FROM ubuntu:xenial
MAINTAINER Mark Waser <mark@artificialgeneralintelligenceinc.com>
ENV DEBIAN_FRONTEND noninteractive
WORKDIR /shared
RUN apt-get update && \
apt-get --no-install-recommends -yq install software-properties-common && \
add-apt-repository ppa:bitcoin/bitcoin && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && \
apt-get --no-install-recommends -yq install \
wget \
libdb4.8-dev \
libdb4.8++-dev \
libboost-all-dev \
libssl-dev \
libevent-dev \
locales \
git-core \
build-essential \
ca-certificates \
autoconf \
automake \
pkg-config \
libtool \
autotools-dev \
bsdmainutils \
vim \
ruby \
rsync \
dos2unix \
tor \
net-tools && \
apt-get -yq purge grub > /dev/null 2>&1 || true && \
apt-get -y dist-upgrade && \
locale-gen en_US.UTF-8 && \
update-locale LANG=en_US.UTF-8 && rm -rf /var/lib/apt/lists/*;

ENV SSH_PASSWD "root:Docker!"
RUN apt-get update \
        && apt-get install -y --no-install-recommends dialog \
        && apt-get update \
  && apt-get install -y --no-install-recommends openssh-server \
  && echo "$SSH_PASSWD" | chpasswd && rm -rf /var/lib/apt/lists/*;

COPY ssh-cb.sh /root/cb.sh
COPY ssh-divi.conf /root/divi.conf
COPY torrc /etc/tor/torrc
COPY sshd_config /etc/ssh/sshd_config
RUN dos2unix /root/cb.sh
RUN dos2unix /root/divi.conf
RUN dos2unix /etc/tor/torrc
RUN dos2unix /etc/ssh/sshd_config

ENV GITBRANCH master
ENV GITURI https://github.com/Divicoin/Divi
RUN /root/cb.sh

COPY ssh-init.sh /usr/local/bin/
RUN dos2unix /usr/local/bin/ssh-init.sh
RUN chmod u+x /usr/local/bin/ssh-init.sh
EXPOSE 80 2222
ENTRYPOINT ["ssh-init.sh"]

