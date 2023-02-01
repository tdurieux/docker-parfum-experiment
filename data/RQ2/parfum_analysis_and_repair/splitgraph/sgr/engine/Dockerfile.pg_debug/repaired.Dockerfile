# Base PostgreSQL debug image, where we compile and install it from source with
# full debugging capabilities. For more details see:
# https://wiki.postgresql.org/wiki/Developer_FAQ#Compile-time
# Note that we use the pre-built PG image from:
# https://github.com/docker-library/postgres/blob/master/12/bullseye/Dockerfile
# and just swap out the binaries and shared libs with the ones installed below.


#####
##### toolchain
#####

FROM postgres:12.3

# Compile and install PG in debug mode

ARG use_valgrind
RUN rm -rf /usr/lib/postgresql/12/* && \
    apt-get update -qq && \
    apt-get install --no-install-recommends -y --allow-downgrades \
        build-essential \
        curl \
        wget \
        git \
        vim \
        libssl-dev \
        libsasl2-dev \
        pkgconf \
        autoconf \
        libtool \
        # https://github.com/docker-library/postgres/issues/678#issuecomment-586888013
        postgresql-server-dev-$PG_MAJOR \
        protobuf-c-compiler \
        libprotobuf-c-dev \
        libpython3.7-dev \
        python3.7 \
        python3-setuptools \
        cmake \
        clang-7 \
        # Debugging tools
        sudo \
        gdb \
        procps \
        # PG source installation reqs
        bison \
        flex \
        build-essential \
        libreadline-dev \
        libffi6-dbg \
        libgcc1-dbg \
        libkrb5-dbg \
        libstdc++6-8-dbg \
        libxml2-dbg \
        zlib1g-dbg \
        zlib1g \
        zlib1g-dev \
        xsltproc \
        libxml2-utils && \
    rm -rf /var/lib/apt/lists/* && \
    # pgprint command for GDB
    git clone https://github.com/tvesely/gdbpg.git && \
    # Download PG source
    git clone -b REL_12_STABLE https://github.com/postgres/postgres.git && \
    # Download Valgrind source, compile and install
    test -z "${use_valgrind}" || (# Make a switcheroo in the image entrypoint, so that instead of starting plain
        # postgres we start it under Valgrind
        sed -i -e 's/"$BASH_SOURCE"/"$BASH_SOURCE" valgrind --leak-check=full --show-leak-kinds=definite,indirect \
--num-callers=25 --log-file=\/pg-valgrind\/valgrind-%p.log --trace-children=yes \
--gen-suppressions=all --suppressions=postgres\/src\/tools\/valgrind.supp \
--suppressions=valgrind-python.supp --verbose --time-stamp=yes \
--error-markers=VALGRINDERROR-BEGIN,VALGRINDERROR-END/' /usr/local/bin/docker-entrypoint.sh && \
        # Configure PG with Valgrind support
        sed -i -e 's=/\*\s#define\sUSE_VALGRIND\s\*/=#define USE_VALGRIND=' postgres/src/include/pg_config_manual.h && \
        # Download Python Valgrind suppressions and make folder for output files
        curl -f https://svn.python.org/projects/python/trunk/Misc/valgrind-python.supp --output valgrind-python.supp && \
        mkdir -p /pg-valgrind && sudo chmod a+w /pg-valgrind && \
        # Build Valgrind
        curl -f https://sourceware.org/pub/valgrind/valgrind-3.18.1.tar.bz2 --output valgrind-3.18.1.tar.bz2 && \
        tar xf valgrind-3.18.1.tar.bz2 && \
        cd valgrind-3.18.1 && \
        ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
        make && \
        make install && \
        cd ..) && \
    # Compile and install PG from source
    cd /postgres && \
    mkdir -p /usr/lib/postgresql/12 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
        --enable-cassert \
        --enable-debug \
        CFLAGS="-ggdb -Og -g3 -fno-omit-frame-pointer" \
        -prefix=/usr/lib/postgresql/12 && \
    make && \
    make install && rm valgrind-3.18.1.tar.bz2
    # Extensions are not installed automatically; install extensions so that
    # we can step through them in GDB (but otherwise they work fine without this).
    # cd contrib && \
    # make all && \
    # make install

# Configure GDB: enable pgprint, disable confirmation and dynamic load prompt
COPY <<EOF /etc/gdb/gdbinit
source /gdbpg/gdbpg.py
set confirm off
set breakpoint pending on
EOF
