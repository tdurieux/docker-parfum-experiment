from saltstack/arch-minimal
MAINTAINER SaltStack, Inc.

# Update System
RUN pacman -Syyu --noconfirm
RUN pacman -Sy --noconfirm --needed base-devel

#   Required Testing Libraries
RUN pacman -Sy --noconfirm \
  git \
  mercurial \
  mysql-python \
  openssh \
  python2-mock \
  python2-pip \
  python2-setuptools \
  python2-virtualenv \
  ruby \
  subversion \
  supervisor \
  tar \
  which

#RUN yaourt -Sy --noconfirm --aur rabbitmq

#   Requirements only available trough PyPi
RUN easy_install-2.7 \
  apache-libcloud \
  coverage \
  psutil \
  timelib \
  GitPython \
  requests \
  keyring \
  python-gnupg \
  CherryPy \
  tornado \
  boto \
  moto \
  https://github.com/saltstack/salt-testing/archive/develop.tar.gz \
  https://github.com/danielfm/unittest-xml-reporting/archive/master.tar.gz

ADD https://raw.github.com/saltstack/docker-containers/master/scripts/bootstrap-docker.sh /bootstrap-docker.sh

ENTRYPOINT ["/bin/sh", "/bootstrap-docker.sh", \
  "supervisord"]
