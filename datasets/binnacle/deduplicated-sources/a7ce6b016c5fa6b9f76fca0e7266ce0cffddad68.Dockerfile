FROM centos:7


ARG TERM=linux

ARG SCIDB_NAME=scidb
ARG SCIDB_LOG_LEVEL=WARN
ARG SCIDB_SCRIPT_URL="https://downloads.paradigm4.com/community/18.1/install-scidb-ce.sh"


ENV SCIDB_VER=18.1   \
    SCIDB_NAME=scidb

ENV SCIDB_INSTALL_PATH=/opt/scidb/$SCIDB_VER

ENV PATH=$PATH:$SCIDB_INSTALL_PATH/bin


## Install dependencies
RUN yum install --assumeyes                     \
        patch                                   \
        wget                                    \
        which                                   \
    && yum clean all


## Get SciDB install script
RUN wget --no-verbose --output-document /install-scidb-ce.sh "$SCIDB_SCRIPT_URL"


## Run SciDB install script
RUN yes                                         \
    |  bash -x /install-scidb-ce.sh             \
    && yum install --assumeyes                  \
        scidb-$SCIDB_VER-dev                    \
    && yum clean all

        # scidb-$SCIDB_VER-libboost-devel         \


## Setup SSH
RUN echo 'StrictHostKeyChecking no'                        \
    >> /etc/ssh/ssh_config                                 \
    && ssh-keygen -f /root/.ssh/id_rsa -q -N ""            \
    && cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys


## Setup SciDB "config.ini"
COPY config.deb.ini $SCIDB_INSTALL_PATH/etc/config.ini


## Setup PostgreSQL and SciDB
RUN echo "127.0.0.1:5432:$SCIDB_NAME:$SCIDB_NAME:`                   \
            date +%s | sha256sum | base64 | head -c 32`"             \
    >  /root/.pgpass                                                 \
    && chmod go-r /root/.pgpass                                      \
    && chmod a+r $SCIDB_INSTALL_PATH/etc/config.ini                  \
    && ssh-keygen -A                                                 \
    && /usr/sbin/sshd                                                \
    && sed --in-place                                                \
        s/\\.\\.\\.0/172.17.0.0/                                     \
        /var/lib/pgsql/9.3/data/pg_hba.conf                          \
    && su --command="                                                \
            /usr/pgsql-9.3/bin/pg_ctl start                          \
                -D /var/lib/pgsql/9.3/data/                          \
                -s                                                   \
                -w                                                   \
                -t 300"                                              \
                postgres                                             \
    && su --command="                                                \
            $SCIDB_INSTALL_PATH/bin/scidb.py init-syscat $SCIDB_NAME \
                --db-password `                                      \
                    cut --delimiter : --fields 5  /root/.pgpass`"    \
        postgres                                                     \
    && $SCIDB_INSTALL_PATH/bin/scidb.py init-all --force $SCIDB_NAME \
    && su --command="                                                \
            /usr/pgsql-9.3/bin/pg_ctl stop                           \
                -D /var/lib/pgsql/9.3/data/                          \
                -s                                                   \
                -m fast"                                             \
                postgres                                             \
    && sed --in-place                                                \
        s/log4j.rootLogger=INFO/log4j.rootLogger=$SCIDB_LOG_LEVEL/   \
        $SCIDB_INSTALL_PATH/share/scidb/log4cxx.properties


## Setup container entrypoint
COPY docker-entrypoint-centos-7.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]


## Port | App
## -----+-----
## 1239 | SciDB iquery
EXPOSE 1239
