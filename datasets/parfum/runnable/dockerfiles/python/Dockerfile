# runnable base
FROM boxcar/raring

# REPOS
RUN apt-get -y update
RUN apt-get install -y -q software-properties-common
RUN add-apt-repository -y "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"
RUN add-apt-repository -y ppa:chris-lea/node.js
RUN apt-get -y update --fix-missing

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

## MEMCACHED
RUN apt-get install -y -q memcached


## APACHE
RUN apt-get install -y -q apache2

## MYSQL
RUN apt-get install -y -q mysql-client mysql-server

# LANGS

## PYTHON
RUN apt-get install -y -q python-software-properties python python-setuptools python-virtualenv python-dev python-distribute python-pip
RUN pip --no-input --exists-action=w install --upgrade pip

# LIBS
RUN apt-get install -y -q libjpeg8-dev zlib1g-dev libfreetype6-dev liblcms1-dev libwebp-dev libtiff-dev

## NODE
RUN apt-get install -y -q nodejs

## APP
ADD app /root

RUN apt-get -y update --fix-missing
