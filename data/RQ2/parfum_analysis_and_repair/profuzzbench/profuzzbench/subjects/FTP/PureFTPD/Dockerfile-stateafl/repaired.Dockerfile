FROM pure-ftpd

# Use ubuntu as default username
USER ubuntu
WORKDIR /home/ubuntu

# Import environment variable to pass as parameter to make (e.g., to make parallel builds with -j)
ARG MAKE_OPT

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
    git clone https://github.com/jedisct1/pure-ftpd.git pure-ftpd-stateafl && \
    cd pure-ftpd-stateafl && \
    git checkout c21b45f && \
    patch -p1 < ${WORKDIR}/fuzzing.patch && \
    ./autogen.sh && \
    CC=${STATEAFL}/afl-clang-fast CXX=${STATEAFL}/afl-clang-fast++ CFLAGS="-g -O0" CXXFLAGS="-g -O0" ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --without-privsep -without-capabilities && \
    make $MAKE_OPT

COPY --chown=ubuntu:ubuntu in-ftp-replay ${WORKDIR}/in-ftp-replay
COPY --chown=ubuntu:ubuntu run-stateafl.sh ${WORKDIR}/run-stateafl
COPY --chown=ubuntu:ubuntu blacklist.sh ${WORKDIR}/blacklist.sh

# Switch default user to root
USER root
WORKDIR /home/ubuntu

# The server runs in chroot jail in "/home/fuzzing" if login succeeds,
# otherwise, the CWD is "/". Create a link to share the same files for MVP tree.
RUN touch /home/fuzzing/.tree.mvp && \
    chmod ugo+rw /home/fuzzing/.tree.mvp && \
    ln /home/fuzzing/.tree.mvp /.tree.mvp

RUN touch /home/fuzzing/.tree.count.mvp && \
    chmod ugo+rw /home/fuzzing/.tree.count.mvp && \
    ln /home/fuzzing/.tree.count.mvp /.tree.count.mvp
