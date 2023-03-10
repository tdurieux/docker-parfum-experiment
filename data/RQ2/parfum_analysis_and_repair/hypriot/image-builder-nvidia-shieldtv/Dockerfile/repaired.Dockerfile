FROM debian:jessie

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    python-pip \
    build-essential \
    libguestfs-tools \
    libncurses5-dev \
    tree \
    binfmt-support \
    qemu \
    qemu-user-static \
    debootstrap \
    kpartx \
    lvm2 \
    dosfstools \
    pigz \
    awscli \
    ruby \
    ruby-dev \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN gem update --system && \
    gem install --no-document serverspec && \
    gem install --no-document pry-byebug && \
    gem install --no-document bundler && rm -rf /root/.gem;

COPY builder/ /builder/

# build sd card image
CMD /builder/build.sh
