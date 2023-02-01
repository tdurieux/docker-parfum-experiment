FROM lightftp

# Import environment variable to pass as parameter to make (e.g., to make parallel builds with -j)
ARG MAKE_OPT

# Set up StateAFL
ENV STATEAFL="/home/ubuntu/stateafl"

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
    git clone https://github.com/hfiref0x/LightFTP.git LightFTP-stateafl && \
    cd LightFTP-stateafl && \
    git checkout 5980ea1 && \
    patch -p1 < ${WORKDIR}/fuzzing.patch && \
    cd Source/Release && \
    CC=${STATEAFL}/afl-clang-fast make clean all $MAKE_OPT


# Set up LightFTP for fuzzing
RUN cd ${WORKDIR}/LightFTP-stateafl/Source/Release && \
    cp ${AFLNET}/tutorials/lightftp/fftp.conf ./ && \
    cp ${AFLNET}/tutorials/lightftp/ftpclean.sh ./

COPY --chown=ubuntu:ubuntu in-ftp-replay ${WORKDIR}/in-ftp-replay
COPY --chown=ubuntu:ubuntu run-stateafl.sh ${WORKDIR}/run-stateafl