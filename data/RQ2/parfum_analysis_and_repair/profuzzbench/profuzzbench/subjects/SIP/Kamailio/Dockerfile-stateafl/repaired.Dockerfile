FROM kamailio

# Use ubuntu as default username
USER ubuntu
WORKDIR /home/ubuntu

# Import environment variable to pass as parameter to make (e.g., to make parallel builds with -j)
ARG MAKE_OPT

# Set up StateAFL
ENV STATEAFL="/home/ubuntu/stateafl"
ENV STATEAFL_CFLAGS="-DBLACKLIST_ALLOC_SITES"

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
    git clone https://github.com/kamailio/kamailio.git kamailio-stateafl && \
    cd kamailio-stateafl && \
    git checkout 2648eb3 && \
    patch -p1 < $WORKDIR/kamailio.patch && \
    CC=${STATEAFL}/afl-clang-fast make MEMPKG=sys cfg && \
    CC=${STATEAFL}/afl-clang-fast make all $MAKE_OPT

COPY --chown=ubuntu:ubuntu in-sip-replay ${WORKDIR}/in-sip-replay
COPY --chown=ubuntu:ubuntu run-stateafl.sh ${WORKDIR}/run-stateafl