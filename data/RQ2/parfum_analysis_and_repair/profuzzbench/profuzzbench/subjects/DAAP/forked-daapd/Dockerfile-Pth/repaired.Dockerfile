FROM ubuntu:18.04

# Install common dependencies
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install sudo \
    apt-utils \
    build-essential \
    openssl \
    clang \
    graphviz-dev \
    git \
    libgnutls28-dev \
    python-pip \
    nano \
    net-tools \
    vim \
    bison \
    flex \
    autotools-dev autoconf automake libtool gettext gawk \
    gperf antlr3 libantlr3c-dev libconfuse-dev libunistring-dev libsqlite3-dev \
    libavcodec-dev libavformat-dev libavfilter-dev libswscale-dev libavutil-dev \
    libasound2-dev libmxml-dev libgcrypt20-dev libavahi-client-dev zlib1g-dev \
    libevent-dev libplist-dev libsodium-dev libjson-c-dev libwebsockets-dev \
    libcurl4-openssl-dev avahi-daemon cmake libpth-dev && rm -rf /var/lib/apt/lists/*;

# Add a new user ubuntu, pass: ubuntu
RUN groupadd ubuntu && \
    useradd -rm -d /home/ubuntu -s /bin/bash -g ubuntu -G sudo -u 1000 ubuntu -p "$(openssl passwd -1 ubuntu)"

# Use ubuntu as default username
USER ubuntu
WORKDIR /home/ubuntu

# Download and compile AFLNet
ENV LLVM_CONFIG="llvm-config-6.0"

# Set up fuzzers
RUN git clone https://github.com/profuzzbench/aflnet.git && \
    cd aflnet && \
    make clean all && \
    cd llvm_mode && make

RUN git clone https://github.com/profuzzbench/aflnwe.git && \
    cd aflnwe && \
    make clean all && \
    cd llvm_mode && make

# Set up environment variables for AFLNet
ENV WORKDIR="/home/ubuntu/experiments"
ENV AFLNET="/home/ubuntu/aflnet"
ENV PATH="${PATH}:${AFLNET}:/home/ubuntu/.local/bin:${WORKDIR}"
ENV AFL_PATH="${AFLNET}"
ENV AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1 \
    AFL_SKIP_CPUFREQ=1 \
    AFL_NO_AFFINITY=1
ENV LD_LIBRARY_PATH=$WORKDIR/libwebsockets/build/lib/:$WORKDIR/libevent/build/lib/:$WORKDIR/gnu-pth/.libs/

RUN mkdir $WORKDIR && \
    pip install --no-cache-dir gcovr==4.2

COPY --chown=ubuntu:ubuntu forked-daapd.patch ${WORKDIR}/forked-daapd.patch
COPY --chown=ubuntu:ubuntu forked-daapd-gcov.patch ${WORKDIR}/forked-daapd-gcov.patch
COPY --chown=ubuntu:ubuntu libevent.patch ${WORKDIR}/libevent.patch
COPY --chown=ubuntu:ubuntu libwebsockets.patch ${WORKDIR}/libwebsockets.patch
COPY --chown=ubuntu:ubuntu in-daap ${WORKDIR}/in-daap
COPY --chown=ubuntu:ubuntu cov_script.sh ${WORKDIR}/cov_script
COPY --chown=ubuntu:ubuntu run.sh ${WORKDIR}/run
COPY --chown=ubuntu:ubuntu MP3 ${WORKDIR}/MP3
COPY --chown=ubuntu:ubuntu forked-daapd.conf ${WORKDIR}/forked-daapd.conf

# Compile dependencies
RUN cd $WORKDIR && \
    git clone https://github.com/danluu/gnu-pth.git && \
    cd gnu-pth && \
    git checkout 5e514e1 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-pthread && \
    make

RUN cd $WORKDIR && \
    git clone https://github.com/libevent/libevent.git && \
    cd libevent && \
    git checkout 5df3037 && \
    patch -p1 < $WORKDIR/libevent.patch && \
    mkdir build && \
    cd build && \
    cmake -DEVENT__DISABLE_TESTS=ON -DEVENT__DISABLE_SAMPLES=ON -DEVENT__DISABLE_REGRESS=ON -DEVENT__DISABLE_BENCHMARK=ON .. && \
    perl -p -i -e 'if(/POLL|EVENTFD|KQUEUE/) { $_ = "//".$_; }' include/event2/event-config.h && \
    make

RUN cd $WORKDIR && \
    git clone https://github.com/warmcat/libwebsockets.git && \
    cd libwebsockets && \
    git checkout 5a247a5 && \
    patch -p1 < $WORKDIR/libwebsockets.patch && \
    mkdir build && \
    cd build && \
    cmake -DLWS_WITHOUT_TESTAPPS=ON -DLWS_WITHOUT_TEST_CLIENT=ON -DLWS_WITHOUT_TEST_ECHO=ON -DLWS_WITHOUT_TEST_FRAGGLE=ON -DLWS_WITHOUT_TEST_PING=ON -DLWS_WITHOUT_TEST_SERVER=ON -DLWS_WITHOUT_TEST_SERVER_EXTPOLL=ON .. && \
    make

# Download and compile forked-daapd for fuzzing
RUN cd $WORKDIR && \
    git clone https://github.com/ejurgensen/forked-daapd.git && \
    cd forked-daapd && \
    git checkout 2ca10d9 && \
    patch -p1 < $WORKDIR/forked-daapd.patch && \
    autoreconf -i && \
    CC=$AFLNET/afl-clang-fast CFLAGS="-DSQLITE_CORE" LDFLAGS="-L$WORKDIR/libevent/build/lib/ -L$WORKDIR/gnu-pth/.libs/ -L$WORKDIR/libwebsockets/build/lib/" LIBS="-lpth" ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-mpd --disable-itunes --disable-lastfm --disable-spotify --disable-verification --disable-shared --enable-static && \
    make clean all


# Download and compile forked-daapd for code coverage analysis
RUN cd $WORKDIR && \
    git clone https://github.com/ejurgensen/forked-daapd.git forked-daapd-gcov && \
    cd forked-daapd-gcov && \
    git checkout 2ca10d9 && \
    patch -p1 < $WORKDIR/forked-daapd.patch && \
    patch -p1 < $WORKDIR/forked-daapd-gcov.patch && \
    autoreconf -i && \
    CFLAGS="-DSQLITE_CORE -fprofile-arcs -ftest-coverage" LDFLAGS="-fprofile-arcs -ftest-coverage -L$WORKDIR/libevent/build/lib/ -L$WORKDIR/gnu-pth/.libs/ -L$WORKDIR/libwebsockets/build/lib/" LIBS="-lpth" ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-mpd --disable-itunes --disable-lastfm --disable-spotify --disable-verification --disable-shared --enable-static && \
    make clean all

# Setting up the environment using root account
USER root

RUN touch /var/log/forked-daapd.log && \
    chown ubuntu.root /var/log/forked-daapd.log

RUN touch /var/run/forked-daapd.pid && \
    chown ubuntu.root /var/run/forked-daapd.pid

RUN update-rc.d avahi-daemon defaults

RUN mkdir /usr/share/forked-daapd/ && \
    cp -R $WORKDIR/forked-daapd/htdocs /usr/share/forked-daapd/htdocs

RUN ln -s $WORKDIR/MP3 /tmp/MP3

#The script needs to launch dbus and avahi-daemon using sudo
RUN echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Switch back to ubuntu account
USER ubuntu
RUN mkdir ${WORKDIR}/db
