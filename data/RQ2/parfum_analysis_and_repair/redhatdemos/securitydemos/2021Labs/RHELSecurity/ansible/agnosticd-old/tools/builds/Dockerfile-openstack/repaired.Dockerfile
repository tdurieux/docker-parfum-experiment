FROM python:alpine

RUN apk add --no-cache --purge -uU \
  gcc \
  musl-dev \
  libffi-dev \
  openssl-dev \
  libressl-dev \
  openssh-client \
  sudo \
  curl \
  git \
  ca-certificates

RUN mkdir -p /etc/ansible \
    && ln -s /usr/local/bin/python /usr/bin/python \
    && rm -rf /var/cache/apk/* /tmp/*

RUN pip3 install --no-cache-dir --no-cache --upgrade pip

RUN pip3 install --no-cache-dir --no-cache \
    python-heatclient \
    python-openstackclient \
    python-neutronclient \
    python-keystoneclient \
    python-novaclient \
    python-glanceclient \
    ansible \
    openstacksdk \
    dnspython

USER ${USER_UID}
