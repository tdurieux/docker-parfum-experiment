FROM debian:8

ARG TERM=linux
ARG DEBIAN_FRONTEND=noninteractive
ARG SCIDB_NAME=scidb

ENV SCIDB_VER=16.9         \
    SCIDB_NAME=$SCIDB_NAME

ENV SCIDB_INSTALL_PATH=/opt/scidb/$SCIDB_VER \
    SCIDB_SHIM=shim_${SCIDB_VER}_amd64.deb

ENV PATH=$PATH:$SCIDB_INSTALL_PATH/bin


## Install dependencies
RUN apt-get update                                          \
    && apt-get install --assume-yes --no-install-recommends \
        apt-transport-https                                 \
        ca-certificates                                     \
        libgomp1                                            \
        libpqxx-dev                                         \
        libscalapack-openmpi1                               \
        openssh-server                                      \
        pkg-config                                          \
        wget                                                \
    && rm -rf /var/lib/apt/lists/*


## Add Paradigm4 and Bintray repositories and install SciDB packages
RUN wget --no-verbose --output-document - https://downloads.paradigm4.com/key \
    |  apt-key add -                                                          \
    && echo "deb https://downloads.paradigm4.com/ ubuntu14.04/3rdparty/"      \
    >  /etc/apt/sources.list.d/scidb.list                                     \
    && apt-key adv                                                            \
        --keyserver hkp://keyserver.ubuntu.com --recv 46BD98A354BA5235        \
    && echo "deb https://dl.bintray.com/rvernica/deb jessie main"             \
    >  /etc/apt/sources.list.d/bintray.list                                   \
    && apt-get update                                                         \
    && apt-get install --assume-yes --no-install-recommends                   \
        paradigm4-$SCIDB_VER-all-coord                                        \
    && rm -rf /var/lib/apt/lists/*


## Setup SSH
RUN echo 'StrictHostKeyChecking no'                                             \
    >> /etc/ssh/ssh_config                                                      \
    && ssh-keygen -f /root/.ssh/id_rsa -q -N ""                                 \
    && cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys


## Setup SciDB "config.ini"
COPY config.deb.ini $SCIDB_INSTALL_PATH/etc/config.ini


## Setup PostgreSQL and SciDB
RUN echo "127.0.0.1:5432:$SCIDB_NAME:$SCIDB_NAME:`                   \
            date +%s | sha256sum | base64 | head -c 32`"             \
    >  /root/.pgpass                                                 \
    && chmod go-r /root/.pgpass                                      \
    && service ssh start                                             \
    && service postgresql start                                      \
    && su --command="                                                \
            $SCIDB_INSTALL_PATH/bin/scidb.py init-syscat $SCIDB_NAME \
                --db-password `                                      \
                    cut --delimiter : --fields 5  /root/.pgpass`"    \
        postgres                                                     \
    && $SCIDB_INSTALL_PATH/bin/scidb.py init-all --force $SCIDB_NAME \
    && service postgresql stop


## Install Shim
RUN wget --no-verbose --output-document /tmp/$SCIDB_SHIM \
        http://paradigm4.github.io/shim/$SCIDB_SHIM      \
    && dpkg --install /tmp/$SCIDB_SHIM


COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]


## Port | App
## -----+-----
## 1239 | SciDB iquery
## 8080 | SciDB Shim (HTTP)
## 8083 | SciDB Shim (HTTPS)
EXPOSE 1239 8080 8083
