FROM forked-daapd

# Use ubuntu as default username
USER ubuntu
WORKDIR /home/ubuntu

# Import environment variable to pass as parameter to make (e.g., to make parallel builds with -j)
ARG MAKE_OPT

# Set up StateAFL
ENV STATEAFL="/home/ubuntu/stateafl"
ENV STATEAFL_CFLAGS="-D__TRACER_USE_PTHREAD_MUTEX"

ENV TRACE_CUSTOM_RECEIVE="evhttp_request_get_uri"
ENV TRACE_CUSTOM_SEND="evhttp_send_reply"

RUN git clone https://github.com/stateafl/stateafl.git $STATEAFL && \
    cd $STATEAFL && \
    make clean all $MAKE_OPT && \
    rm as && \
    cd llvm_mode && CFLAGS="${STATEAFL_CFLAGS}" make $MAKE_OPT

# Set up environment variables for StateAFL
ENV AFL_PATH=${STATEAFL}
ENV PATH=${STATEAFL}:${PATH}

# Dedicated instrumented version for StateAFL
RUN cd $WORKDIR && \
    git clone https://github.com/ejurgensen/forked-daapd.git forked-daapd-stateafl && \
    cd forked-daapd-stateafl && \
    git checkout 2ca10d9 && \
    patch -p1 < $WORKDIR/forked-daapd.patch && \
    autoreconf -i && \
    CC=${STATEAFL}/afl-clang-fast CFLAGS="-DSQLITE_CORE" ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-mpd --disable-itunes --disable-lastfm --disable-spotify --disable-verification --disable-shared --enable-static && \
    make -C src/ SMARTPL2SQL.c SMARTPL.c DAAP2SQL.c DAAPLexer.c RSPLexer.c RSP2SQL.c && \
    make clean all $MAKE_OPT

COPY --chown=ubuntu:ubuntu in-daap-replay ${WORKDIR}/in-daap-replay
COPY --chown=ubuntu:ubuntu run-stateafl.sh ${WORKDIR}/run-stateafl

