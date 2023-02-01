# Perdocker
#
# VERSION               0.0.1

FROM      ubuntu
MAINTAINER Nox73

# make sure the package repository is up to date
RUN apt-get install --no-install-recommends -y curl build-essential lamp-server^ && rm -rf /var/lib/apt/lists/*;

WORKDIR /tmp/

RUN curl -f https://nodejs.org/dist/v0.10.24/node-v0.10.24-linux-x64.tar.gz > node-v0.10.24-linux-x64.tar.gz
RUN tar -xvzf node-v0.10.24-linux-x64.tar.gz && rm node-v0.10.24-linux-x64.tar.gz
RUN mv node-v0.10.24-linux-x64 /usr/local/node
RUN ln -s /usr/local/node/bin/node /usr/bin/node

RUN groupadd perdocker
RUN useradd -g perdocker perdocker

USER perdocker
