FROM debian:stretch

MAINTAINER Irontec IvozProvider Team <ivozprovider@irontec.com>

RUN apt-get update && apt-get install --no-install-recommends -y \
    gnupg \
    sudo \
    wget \
    unzip \
    build-essential \
    python \
    python-dev \
    python-clint \
    python-setuptools \
    python-junit.xml \
    python-yaml \
    libasound2-dev && rm -rf /var/lib/apt/lists/*;

# Download and compile pjproject
WORKDIR /usr/src/
RUN wget https://github.com/pjsip/pjproject/archive/refs/tags/2.6.tar.gz -O pjproject-2.6.tar.bz2
RUN tar xzvf /usr/src/pjproject-2.6.tar.bz2 && rm /usr/src/pjproject-2.6.tar.bz2
WORKDIR /usr/src/pjproject-2.6
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-shared && make dep && make && make install
WORKDIR /usr/src/pjproject-2.6/pjsip-apps/src/python
RUN make && make install && ldconfig

# Download and compile bss
WORKDIR /usr/src/
RUN wget https://github.com/irontec/bbs/archive/refs/heads/master.zip -O bbs-master.zip
RUN unzip bbs-master.zip
WORKDIR /usr/src/bbs-master
RUN python setup.py build && python setup.py install

# Create jenkins user (configurable)
ARG UNAME=jenkins
ARG UID=108
ARG GID=117
RUN groupadd -g $GID $UNAME
RUN useradd -m -u $UID -g $GID -s /bin/bash $UNAME

# Add jenkins to sudoers file
RUN echo "$UNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Base project
USER $UNAME

WORKDIR /opt/irontec/ivozprovider/
