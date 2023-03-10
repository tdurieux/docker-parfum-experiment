FROM debian:unstable

RUN apt-get update -qq && apt-get install --no-install-recommends -qq -y \
    autoconf \
    automake \
    build-essential \
    dblatex \
    docbook \
    docbook-xml \
    docbook-xsl \
    libglib2.0-dev \
    libtool \
    libxml2-utils \
    locales \
    make \
    meson \
    pkg-config \
    python3 \
    python3-coverage \
    python3-dev \
    python3-lxml \
    python3-parameterized \
    python3-pip \
    python3-pygments \
    python3-setuptools \
    python3-unittest2 \
    xsltproc \
 && rm -rf /usr/share/doc/* /usr/share/man/* && rm -rf /var/lib/apt/lists/*;

# Locale for our build
RUN locale-gen C.UTF-8 && /usr/sbin/update-locale LANG=C.UTF-8

# Locales for our tests
RUN locale-gen de_DE.UTF-8 \
 && locale-gen el_GR.UTF-8 \
 && locale-gen en_US.UTF-8 \
 && locale-gen es_ES.UTF-8 \
 && locale-gen fa_IR.UTF-8 \
 && locale-gen fr_FR.UTF-8 \
 && locale-gen hr_HR.UTF-8 \
 && locale-gen ja_JP.UTF-8 \
 && locale-gen lt_LT.UTF-8 \
 && locale-gen pl_PL.UTF-8 \
 && locale-gen ru_RU.UTF-8 \
 && locale-gen tr_TR.UTF-8

ENV LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=C.UTF-8

RUN pip3 install --no-cache-dir meson==0.50.0 anytree
ARG HOST_USER_ID=5555
ENV HOST_USER_ID ${HOST_USER_ID}
RUN useradd -u $HOST_USER_ID -ms /bin/bash user

USER user
WORKDIR /home/user

ENV LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=C.UTF-8
