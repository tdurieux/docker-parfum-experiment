# runnable base
FROM boxcar/raring

# REPOS
RUN apt-get -y update
RUN apt-get install --no-install-recommends -y -q software-properties-common && rm -rf /var/lib/apt/lists/*;
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
RUN apt-get install --no-install-recommends -y -q vim nano && rm -rf /var/lib/apt/lists/*;

# TOOLS
RUN apt-get install --no-install-recommends -y -q curl git make wget && rm -rf /var/lib/apt/lists/*;

# BUILD
RUN apt-get install --no-install-recommends -y -q build-essential g++ && rm -rf /var/lib/apt/lists/*;

# SERVICES

## COUCHDB
RUN apt-get install --no-install-recommends -y -q couchdb && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /var/run/couchdb

## REDIS
RUN apt-get install --no-install-recommends -y -q redis-server && rm -rf /var/lib/apt/lists/*;

## MONGO
RUN apt-get install --no-install-recommends -y -q mongodb-10gen && rm -rf /var/lib/apt/lists/*;

## SETUP DBPATH
RUN mkdir -p /data/db

## MYSQL
RUN apt-get install --no-install-recommends -y -q mysql-client mysql-server && rm -rf /var/lib/apt/lists/*;

# LANGS

## GVM
RUN apt-get install --no-install-recommends -y -q golang && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q mercurial && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q bison && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q binutils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q gcc && rm -rf /var/lib/apt/lists/*;
RUN curl -f -s https://raw.github.com/moovweb/gvm/master/binscripts/gvm-installer | bash
RUN bash -c "source $HOME/.gvm/scripts/gvm && gvm install go1.1.1"
RUN bash -c "source $HOME/.gvm/scripts/gvm && gvm use go1.1.1"

## NODE
RUN apt-get install --no-install-recommends -y -q nodejs && rm -rf /var/lib/apt/lists/*;

## APP
ADD hello_world /root
RUN bash -c "cd root && source $HOME/.gvm/scripts/gvm && gvm use go1.1.1 && go build hello_world.go"

# RESET
ENV DEBIAN_FRONTEND dialog

## CONFIG
ENV RUNNABLE_USER_DIR /root
ENV RUNNABLE_SERVICE_CMDS couchdb; redis-server; mongod; mysqld
ENV RUNNABLE_START_CMD ./hello_world