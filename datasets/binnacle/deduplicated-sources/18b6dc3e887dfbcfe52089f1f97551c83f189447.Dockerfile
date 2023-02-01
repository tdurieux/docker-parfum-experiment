FROM ubuntu:18.04

LABEL maintainer="Erwin Dondorp <saltgui@dondorp.com>"
LABEL name=salt-minion
LABEL project="SaltGUI testing"
LABEL version=2019.2.0

ENV SALT_VERSION=2019.2.0
ENV DEBIAN_FRONTEND=noninteractive

# add saltstack key and install dependencies
RUN apt-get update \
  && apt-get install curl gnupg2 net-tools --yes --no-install-recommends \
  && apt-key adv --fetch-keys http://repo.saltstack.com/py3/ubuntu/18.04/amd64/latest/SALTSTACK-GPG-KEY.pub \
  && echo "deb http://repo.saltstack.com/py3/ubuntu/18.04/amd64/latest bionic main" > /etc/apt/sources.list.d/saltstack.list \
  # install salt-minion
  && apt-get update \
  && apt-get install salt-minion=${SALT_VERSION}* --yes --no-install-recommends \
  # show which versions are installed
  && dpkg -l | grep salt- \
  # cleanup temporary files
  && rm -rf /var/lib/apt/lists/* \
  && apt-get -y autoremove \
  && apt-get clean

# copy the minion configuration
COPY ./conf/minion /etc/salt/minion

# define main container command
CMD /usr/bin/salt-minion
