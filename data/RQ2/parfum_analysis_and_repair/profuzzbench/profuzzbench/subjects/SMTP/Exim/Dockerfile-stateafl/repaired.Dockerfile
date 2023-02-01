FROM exim

# Import environment variable to pass as parameter to make (e.g., to make parallel builds with -j)
ARG MAKE_OPT

# Set up StateAFL
ENV STATEAFL="/home/ubuntu/stateafl"
ENV STATEAFL_CFLAGS="-DBLACKLIST_GLOBALS -DENABLE_TRACE_GLOBAL_DATA -DBLACKLIST_ALLOC_SITES"

RUN git clone https://github.com/stateafl/stateafl.git $STATEAFL && \
    cd $STATEAFL && \
    make clean all $MAKE_OPT && \
    rm as && \
    cd llvm_mode && CFLAGS="${STATEAFL_CFLAGS}" make $MAKE_OPT

# Set up environment variables for StateAFL
ENV AFL_PATH=${STATEAFL}
ENV PATH=${STATEAFL}:${PATH}

# Dedicated instrumented version for StateAFL
RUN cd ${WORKDIR} && \
    git clone https://github.com/Exim/exim exim-stateafl && \
    cd exim-stateafl && \
    git checkout 38903fb && \
    patch -p1 < ${WORKDIR}/exim-rand.patch && \
    patch -p1 < ${WORKDIR}/exim-log-bug.patch && \
    cd src; mkdir Local; cp src/EDITME Local/Makefile && \
    cd Local; patch -p1 < ${WORKDIR}/exim.patch; cd .. && \
    make CC=${STATEAFL}/afl-clang-fast clean all $MAKE_OPT


COPY --chown=ubuntu:ubuntu in-smtp-replay ${WORKDIR}/in-smtp-replay
COPY --chown=ubuntu:ubuntu run-stateafl.sh ${WORKDIR}/run-stateafl
COPY --chown=ubuntu:ubuntu blacklist_global.sh ${WORKDIR}/blacklist_global.sh
COPY --chown=ubuntu:ubuntu blacklist_alloc.sh ${WORKDIR}/blacklist_alloc.sh

# For deterministic timestamps in email traffic
RUN cd ${WORKDIR} && \
    git clone https://github.com/stateafl/libfaketime-asan-fixed libfaketime-asan-fixed && \
    cd libfaketime-asan-fixed && \
    git checkout 7e46ea4 && \
    cd src && \
    make

ENV LD_PRELOAD=$WORKDIR/libfaketime-asan-fixed/src/libfaketime.so.1
ENV FAKETIME="2000-01-01 11:12:13"
ENV FAKETIME_ONLY_CMDS="exim"