ARG BASE_IMAGE
FROM $BASE_IMAGE
LABEL maintainer="DECENT"

# prepare directories
ENV DCORE_HOME=/root
ENV DCORE_USER=root
USER $DCORE_USER
WORKDIR $DCORE_HOME

# build DCore
ARG GIT_REV=master
RUN git clone --single-branch --branch $GIT_REV https://github.com/DECENTfoundation/DECENT-Network.git && \
    cd DECENT-Network && git submodule update --init --recursive && \
    mkdir build && cd build && \
    cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release .. && \
    make -j$(nproc) decentd cli_wallet && \
    cp programs/decentd/decentd programs/cli_wallet/cli_wallet /usr/bin && \
    cd ../.. && rm -rf DECENT-Network && mkdir $DCORE_HOME/.decent

EXPOSE 40000
EXPOSE 8090

ENV DCORE_EXTRA_ARGS=""
CMD decentd -d $DCORE_HOME/.decent/data --rpc-endpoint 0.0.0.0:8090 $DCORE_EXTRA_ARGS
