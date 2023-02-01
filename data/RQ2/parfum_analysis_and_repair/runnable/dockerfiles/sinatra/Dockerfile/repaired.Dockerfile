# runnable base
FROM boxcar/raring

# REPOS
RUN apt-get -y update
RUN apt-get install --no-install-recommends -y -q software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"
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

## MYSQL
RUN apt-get install --no-install-recommends -y -q mysql-client && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q mysql-server && rm -rf /var/lib/apt/lists/*;

# LANGS

## RUBY
RUN apt-get install --no-install-recommends -y -q ruby && rm -rf /var/lib/apt/lists/*;

## SINATRA
RUN gem install sinatra

ENV DEBIAN_FRONTEND dialog