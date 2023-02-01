FROM bftpd

# Use ubuntu as default username
USER ubuntu
WORKDIR /home/ubuntu

# Import environment variable to pass as parameter to make (e.g., to make parallel builds with -j)
ARG MAKE_OPT

# Set up StateAFL
ENV STATEAFL="/home/ubuntu/stateafl"
ENV STATEAFL_CFLAGS="-DENABLE_TRACE_GLOBAL_DATA -DBLACKLIST_GLOBALS"

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
    mkdir ${WORKDIR}/bftpd-stateafl && \
    tar -zxvf bftpd-5.7.tar.gz -C ${WORKDIR}/bftpd-stateafl --strip-components=1 && \
    cd ${WORKDIR}/bftpd-stateafl && \
    patch -p1 < ${WORKDIR}/fuzzing.patch && \
    CC=${STATEAFL}/afl-clang-fast ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    CC=${STATEAFL}/afl-clang-fast make clean all $MAKE_OPT && rm bftpd-5.7.tar.gz

COPY --chown=ubuntu:ubuntu in-ftp-replay ${WORKDIR}/in-ftp-replay
COPY --chown=ubuntu:ubuntu run-stateafl.sh ${WORKDIR}/run-stateafl
COPY --chown=ubuntu:ubuntu blacklist_asan.sh ${WORKDIR}/blacklist_asan.sh

# Switch default user to root
USER root
WORKDIR /home/ubuntu


