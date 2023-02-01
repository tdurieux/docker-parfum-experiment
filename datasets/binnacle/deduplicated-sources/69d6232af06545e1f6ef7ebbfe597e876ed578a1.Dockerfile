FROM debian:8

ARG TERM=linux
ARG DEBIAN_FRONTEND=noninteractive

ENV SCIDB_VER=16.9            \
    SCIDB_VER_MINOR=5.24119eb \
    SCIDB_SOURCE_URL="https://docs.google.com/uc?id=0Bx6-HAs-dV5CQjlZZDJpamY0dEk&export=download"

ENV SCIDB_SOURCE_PATH=/usr/local/src/scidb-$SCIDB_VER.$SCIDB_VER_MINOR \
    SCIDB_INSTALL_PATH=/opt/scidb/$SCIDB_VER                           \
    SCIDB_BUILD_TYPE=Release

ENV PATH=$PATH:$SCIDB_INSTALL_PATH/bin


## Install dependencies
RUN apt-get update                                          \
    && apt-get install --assume-yes --no-install-recommends \
        apt-transport-https                                 \
        bison                                               \
        ca-certificates                                     \
        cmake                                               \
        flex                                                \
        g++                                                 \
        gfortran                                            \
        libbz2-dev                                          \
        libcppunit-dev                                      \
        liblapack-dev                                       \
        liblog4cxx10-dev                                    \
        libpqxx-dev                                         \
        libprotobuf-dev                                     \
        libreadline6-dev                                    \
        make                                                \
        openssh-server                                      \
        patch                                               \
        pkg-config                                          \
        postgresql                                          \
        postgresql-contrib                                  \
        protobuf-compiler                                   \
        python                                              \
        python-paramiko                                     \
        sudo                                                \
        unzip                                               \
        wget                                                \
   && rm -rf /var/lib/apt/lists/*


## Install openjdk-8-jdk from jessie-backports
## Install dependencies requiring default-jre-headless
RUN echo "deb http://http.debian.net/debian jessie-backports main" \
    >  /etc/apt/sources.list.d/jessie-backports.list               \
    && apt-get update                                              \
    && apt-get install --assume-yes --no-install-recommends        \
        ant                                                        \
        ant-contrib                                                \
        ca-certificates-java/jessie-backports                      \
        junit                                                      \
        libprotobuf-java                                           \
        openjdk-8-jdk                                              \
        openjdk-8-jre-headless                                     \
    && rm -rf /var/lib/apt/lists/*


## Install Paradigm4 packages
RUN wget --no-verbose --output-document - https://downloads.paradigm4.com/key \
    |  apt-key add -                                                          \
    && echo "deb https://downloads.paradigm4.com/ ubuntu14.04/3rdparty/"      \
    >  /etc/apt/sources.list.d/scidb.list                                     \
    && apt-get update                                                         \
    && apt-get install --assume-yes --no-install-recommends                   \
        scidb-$SCIDB_VER-ant                                                  \
        scidb-$SCIDB_VER-cityhash                                             \
        scidb-$SCIDB_VER-libboost1.54-all-dev                                 \
        scidb-$SCIDB_VER-libcsv                                               \
        scidb-$SCIDB_VER-libmpich2-dev                                        \
        scidb-$SCIDB_VER-mpich2                                               \
    && rm -rf /var/lib/apt/lists/*


## Get SciDB source code
RUN mkdir $SCIDB_SOURCE_PATH                                                 \
    && wget --no-verbose --output-document - --load-cookies cookies.txt      \
        "$SCIDB_SOURCE_URL&`                                                 \
            wget --no-verbose --output-document - --save-cookies cookies.txt \
                "$SCIDB_SOURCE_URL"                                          \
            |  grep --only-matching 'confirm=[^&]*'`"                        \
    |  tar --extract --gzip --directory=$SCIDB_SOURCE_PATH


## Apply Debian 8 patches
COPY patch $SCIDB_SOURCE_PATH-patch/
RUN cd $SCIDB_SOURCE_PATH             \
    && cat $SCIDB_SOURCE_PATH-patch/* \
    |  patch --strip=1


## Build SciDB libraries (first few libs only)
RUN cd $SCIDB_SOURCE_PATH                                       \
    && env PATH=$PATH:/opt/scidb/$SCIDB_VER/3rdparty/mpich2/bin \
        ./run.py setup --force                                  \
    && cd stage/build                                           \
    && make -j2                                                 \
        MurmurHash_lib                                          \
        json_lib                                                \
        scidb_msg_lib                                           \
        system_lib                                              \
        storage_lib                                             \
        util_lib                                                \
        catalog_lib                                             \
        compression_lib                                         \
        array_lib                                               \
        ops_lib
    # $SCIDB_SOURCE_PATH/run.py make -j2
