FROM rvernica/scidb:18.1


## Install dependencies
RUN apt-get update                                              \
    && apt-get install --assume-yes --no-install-recommends     \
        bc                                                      \
        gcc                                                     \
        libpcre3-dev                                            \
        libpqxx-dev                                             \
    && rm -rf /var/lib/apt/lists/*                              \
    && wget --no-verbose https://bootstrap.pypa.io/get-pip.py   \
    && python get-pip.py                                        \
    && pip install scidb-strm


ARG SCIDB_DEV_TOOLS=90aa0db6af31b48e69ba9ad1c15e632a0aa4b0fa


## Install dev_tools
RUN wget --no-verbose --output-document -                                      \
        https://github.com/Paradigm4/dev_tools/archive/$SCIDB_DEV_TOOLS.tar.gz \
    |  tar --extract --gzip --directory=/usr/local/src                         \
    && make --directory=/usr/local/src/dev_tools-$SCIDB_DEV_TOOLS              \
    && cp /usr/local/src/dev_tools-$SCIDB_DEV_TOOLS/*.so                       \
        $SCIDB_INSTALL_PATH/lib/scidb/plugins                                  \
    && rm -rf /usr/local/src/dev_tools-$SCIDB_DEV_TOOLS


## Install Paradigm4 plug-ins
RUN wget --output-document=-                                    \
        https://paradigm4.github.io/extra-scidb-libs/install.sh \
    |  sh


## Load plug-ins
## Re-create ".pgpass" file due to hard links created by Docker Hub
RUN cp /root/.pgpass /root/.pgpass.bk          \
    && mv /root/.pgpass.bk /root/.pgpass       \
    && service ssh start                       \
    && service postgresql start                \
    && scidb.py startall $SCIDB_NAME           \
    && iquery --afl --query                    \
        "load_library('dev_tools');            \
         load_library('accelerated_io_tools'); \
         load_library('equi_join');            \
         load_library('grouped_aggregate');    \
         load_library('stream');               \
         load_library('superfunpack')"         \
    && scidb.py stopall $SCIDB_NAME            \
    && service postgresql stop


## Update Shim conf to use aio
RUN echo aio=1            \
    >> /var/lib/shim/conf
