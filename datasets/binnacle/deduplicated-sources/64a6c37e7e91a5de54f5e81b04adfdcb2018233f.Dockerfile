FROM debian:8

ARG TERM=linux
ARG DEBIAN_FRONTEND=noninteractive

ENV SCIDB_VER=15.12           \
    SCIDB_VER_MINOR=1.4cadab5 \
    SCIDB_SOURCE_URL="https://docs.google.com/uc?id=0B7yt0n33Us0raWtCYmNlZWRxWG8&export=download"

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


## Build and install libpqxx3 from wheezy
RUN echo "deb-src http://http.debian.net/debian wheezy main"  \
    >  /etc/apt/sources.list.d/wheezy.list                    \
    && apt-get update                                         \
    && apt-get build-dep --assume-yes --no-install-recommends \
        libpqxx3                                              \
    && mkdir /usr/local/src/libpqxx3                          \
    && cd /usr/local/src/libpqxx3                             \
    && apt-get source --build                                 \
        libpqxx3                                              \
    && apt-get purge --assume-yes                             \
        autotools-dev                                         \
        bsdmainutils                                          \
        build-essential                                       \
        bzip2                                                 \
        chrpath                                               \
        debhelper                                             \
        dpkg-dev                                              \
        file                                                  \
        gettext                                               \
        gettext-base                                          \
        groff-base                                            \
        intltool-debian                                       \
        libasprintf0c2                                        \
        libcroco3                                             \
        libdpkg-perl                                          \
        libgdbm3                                              \
        libmagic1                                             \
        libpipeline1                                          \
        libtimedate-perl                                      \
        libtool                                               \
        libunistring0                                         \
        man-db                                                \
        perl                                                  \
        perl-modules                                          \
        po-debconf                                            \
        xz-utils                                              \
    && dpkg --install                                         \
        libpqxx-3.1_3.1-1.1_amd64.deb                         \
        libpqxx3-dev_3.1-1.1_amd64.deb                        \
    && rm -rf                                                 \
        /etc/apt/sources.list.d/wheezy.list                   \
        /usr/local/src/libpqxx3                               \
        /var/lib/apt/lists/*


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
RUN wget --no-verbose --output-document - --load-cookies cookies.txt         \
        "$SCIDB_SOURCE_URL&`                                                 \
            wget --no-verbose --output-document - --save-cookies cookies.txt \
                "$SCIDB_SOURCE_URL"                                          \
            |  grep --only-matching 'confirm=[^&]*'`"                        \
    |  tar --extract --gzip --directory=/usr/local/src


## Apply SciDB patches
# ADD https://docs.google.com/uc?id=0B8eyzr2ndWOTSFRXWHhOc1ZYTGM&export=download \
#     $SCIDB_SOURCE_PATH/src/query/ops/input/ChunkLoader.h
# ADD https://docs.google.com/uc?id=0B8eyzr2ndWOTakhoVjloS2l1aVE&export=download \
#     $SCIDB_SOURCE_PATH/src/query/ops/input/ChunkLoader.cpp


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
         MurmurHash_lib                                         \
         dmalloc                                                \
         linear_algebra                                         \
         jdbc_build                                             \
         benchGen                                               \
         dgenerator                                             \
         gen_matrix                                             \
         arg_separator                                          \
         preparecdashreport                                     \
         point                                                  \
         rational                                               \
         complex                                                \
         ra_decl                                                \
         more_math                                              \
         match                                                  \
         bestmatch                                              \
         savebmp                                                \
         operators                                              \
         fits                                                   \
         scidb_msg_lib                                          \
         dense_linear_algebra                                   \
         mpi_slave_direct                                       \
         mpi_slave_scidb                                        \
         iquery                                                 \
         scidbtest                                              \
         array_lib                                              \
         scidbtestharness
    # $SCIDB_SOURCE_PATH/run.py make -j2
