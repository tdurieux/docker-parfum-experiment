# runnable base
FROM boxcar/raring

# REPOS
RUN apt-get -y update
RUN apt-get install --no-install-recommends -y -q software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"
RUN add-apt-repository -y ppa:chris-lea/node.js
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/10gen.list
RUN apt-get -y update

#SHIMS
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl
ENV DEBIAN_FRONTEND noninteractive

# EDITORS
RUN apt-get install --no-install-recommends -y -q vim nano && rm -rf /var/lib/apt/lists/*;

# TOOLS
RUN apt-get install --no-install-recommends -y -q curl git make wget && rm -rf /var/lib/apt/lists/*;


# BUILD
RUN apt-get install --no-install-recommends -y -q build-essential g++ && rm -rf /var/lib/apt/lists/*;

# SERVICES

## APACHE
RUN apt-get install --no-install-recommends -y -q apache2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q libapache2-mod-mono mono-apache-server2 && rm -rf /var/lib/apt/lists/*;
RUN a2enmod mod_mono_auto
RUN apt-get -y -q update

## MYSQL
RUN apt-get install --no-install-recommends -y -q mysql-client mysql-server && rm -rf /var/lib/apt/lists/*;
RUN mysqld & sleep 2 && mysqladmin create mydb

# LANGS

## NODE
RUN apt-get install --no-install-recommends -y -q nodejs && rm -rf /var/lib/apt/lists/*;

# RESET
ENV DEBIAN_FRONTEND dialog

# INSTALL MONO
RUN apt-get install --no-install-recommends -y -q mono-complete && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q mono-xsp && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q mono-xsp2 && rm -rf /var/lib/apt/lists/*;

## CONFIG
ENV RUNNABLE_USER_DIR /var/www
ENV RUNNABLE_SERVICE_CMDS /etc/init.d/apache2 restart
