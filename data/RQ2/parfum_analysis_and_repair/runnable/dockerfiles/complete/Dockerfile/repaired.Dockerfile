# runnable base
FROM boxcar/raring

# REPOS
RUN apt-get -y update
RUN apt-get install --no-install-recommends -y -q software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"
RUN add-apt-repository -y ppa:gophers/go/ubuntu
RUN add-apt-repository -y ppa:chris-lea/node.js
RUN add-apt-repository -y ppa:webupd8team/java
RUN add-apt-repository -y ppa:nginx/stable
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/10gen.list
RUN apt-get -y update

#SHIMS
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl
ENV DEBIAN_FRONTEND noninteractive

# EDITORS
RUN apt-get install --no-install-recommends -y -q vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q nano && rm -rf /var/lib/apt/lists/*;

# TOOLS
RUN apt-get install --no-install-recommends -y -q curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q make && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q wget && rm -rf /var/lib/apt/lists/*;
# RUN apt-get install -y -q supervisor

# BUILD
RUN apt-get install --no-install-recommends -y -q build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q g++ && rm -rf /var/lib/apt/lists/*;

# SERVICES

## MEMCACHED
RUN apt-get install --no-install-recommends -y -q memcached && rm -rf /var/lib/apt/lists/*;
#RUN pecl install -y memcache

## COUCHDB
RUN apt-get install --no-install-recommends -y -q couchdb && rm -rf /var/lib/apt/lists/*;

## REDIS
RUN apt-get install --no-install-recommends -y -q redis-server && rm -rf /var/lib/apt/lists/*;

## MONGO
RUN apt-get install --no-install-recommends -y -q mongodb-10gen && rm -rf /var/lib/apt/lists/*;

## POSTGRES
RUN echo "#!/bin/sh\nexit 101" > /usr/sbin/policy-rc.d; chmod +x /usr/sbin/policy-rc.d
RUN apt-get install --no-install-recommends -y -q postgresql-9.1 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q postgresql-contrib-9.1 && rm -rf /var/lib/apt/lists/*;
RUN rm /usr/sbin/policy-rc.d
RUN apt-get install --no-install-recommends -y -q pgadmin3 && rm -rf /var/lib/apt/lists/*;

## MAGICK
RUN apt-get install --no-install-recommends -y -q imagemagick && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q graphicsmagick && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q graphicsmagick-libmagick-dev-compat && rm -rf /var/lib/apt/lists/*;
# #RUN pecl install -y imagick

## APACHE
RUN apt-get install --no-install-recommends -y -q apache2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q libapache2-mod-php5 && rm -rf /var/lib/apt/lists/*;

## MYSQL
RUN apt-get install --no-install-recommends -y -q mysql-client && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q mysql-server && rm -rf /var/lib/apt/lists/*;

## NGINX
RUN apt-get install --no-install-recommends -y -q nginx && rm -rf /var/lib/apt/lists/*;

# LANGS

## GO
RUN apt-get install --no-install-recommends -y -q golang && rm -rf /var/lib/apt/lists/*;

## RUBY
RUN apt-get install --no-install-recommends -y -q ruby && rm -rf /var/lib/apt/lists/*;

## NODE
RUN apt-get install --no-install-recommends -y -q nodejs && rm -rf /var/lib/apt/lists/*;

## PHP
RUN apt-get install --no-install-recommends -y -q php5 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q php-pear && rm -rf /var/lib/apt/lists/*;

## ERLANG
RUN apt-get install --no-install-recommends -y -q erlang && rm -rf /var/lib/apt/lists/*;

# # # JAVA
# # # Broken
# # RUN debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
# # RUN debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
# # RUN apt-get install -y -q oracle-java7-installer

## PYTHON
RUN apt-get install --no-install-recommends -y -q python-software-properties && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q python && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q python-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q python-distribute && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip --no-input --no-cache-dir --exists-action=w install --upgrade pip

# LIBS
RUN apt-get install --no-install-recommends -y -q libjpeg8-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q libfreetype6-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q liblcms1-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q libwebp-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q libtiff-dev && rm -rf /var/lib/apt/lists/*;

ENV DEBIAN_FRONTEND dialog