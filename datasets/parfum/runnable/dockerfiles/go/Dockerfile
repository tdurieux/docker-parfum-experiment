# runnable base
FROM boxcar/raring

# REPOS
RUN apt-get -y update
RUN apt-get install -y -q software-properties-common
RUN add-apt-repository -y "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"
RUN add-apt-repository -y ppa:chris-lea/node.js
RUN add-apt-repository -y ppa:gophers/go/ubuntu
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/10gen.list
RUN apt-get -y update

#SHIMS
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl
ENV DEBIAN_FRONTEND noninteractive

# EDITORS
RUN apt-get install -y -q vim nano

# TOOLS
RUN apt-get install -y -q curl git make wget

# BUILD
RUN apt-get install -y -q build-essential g++

# SERVICES

## COUCHDB
RUN apt-get install -y -q couchdb
RUN mkdir -p /var/run/couchdb

## REDIS
RUN apt-get install -y -q redis-server

## MONGO
RUN apt-get install -y -q mongodb-10gen

## SETUP DBPATH
RUN mkdir -p /data/db

## MYSQL
RUN apt-get install -y -q mysql-client mysql-server

# LANGS

## GVM
RUN apt-get install -y -q golang
RUN apt-get install -y -q mercurial
RUN apt-get install -y -q bison
RUN apt-get install -y -q binutils
RUN apt-get install -y -q gcc
RUN curl -s https://raw.github.com/moovweb/gvm/master/binscripts/gvm-installer | bash
RUN bash -c "source $HOME/.gvm/scripts/gvm && gvm install go1.1.1"
RUN bash -c "source $HOME/.gvm/scripts/gvm && gvm use go1.1.1"

## NODE
RUN apt-get install -y -q nodejs

## APP
ADD hello_world /root
RUN bash -c "cd root && source $HOME/.gvm/scripts/gvm && gvm use go1.1.1 && go build hello_world.go"

# RESET
ENV DEBIAN_FRONTEND dialog

## CONFIG
ENV RUNNABLE_USER_DIR /root
ENV RUNNABLE_SERVICE_CMDS couchdb; redis-server; mongod; mysqld
ENV RUNNABLE_START_CMD ./hello_world