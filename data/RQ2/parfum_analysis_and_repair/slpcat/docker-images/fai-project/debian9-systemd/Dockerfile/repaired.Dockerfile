FROM slpcat/debian:stretch-systemd
MAINTAINER 若虚 <slpcat@qq.com>

RUN apt-get install --no-install-recommends -y gnupg2 && rm -rf /var/lib/apt/lists/*;

# Install packages https://fai-project.org/download/
RUN curl -f --silent https://fai-project.org/download/074BCDE4.asc | \
      apt-key --keyring /etc/apt/trusted.gpg.d/fai-keyring.gpg add - && \
    echo "deb http://fai-project.org/download stretch koeln" > \
      /etc/apt/sources.list.d/fai.list && \
    apt-get update  -qq && \
    apt-get upgrade -qq -y && \
    apt-get install --no-install-recommends -qq -y \
      fai-server syslinux nfs-ganesha apt-cacher-ng nginx && \
    apt-get clean all && rm -rf /var/lib/apt/lists/*;

#use configs and linux images from slpcat
WORKDIR /root
RUN \
git clone https://github.com/slpcat/fai_config

#change apt-cacher-ng config
COPY acng.conf /etc/apt-cacher-ng/acng.conf

VOLUME [ "/srv", "/tmp" ]
