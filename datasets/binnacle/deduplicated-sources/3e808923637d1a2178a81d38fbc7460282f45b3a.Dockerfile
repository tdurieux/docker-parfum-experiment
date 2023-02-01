# Docker container for running Sol-R viewer
FROM ubuntu:xenial

ENV DIST_PATH /app/dist
ENV BUILD_TOOLS build-essential cmake git wget freeglut3-dev

# Set working dir and copy Sol-R assets
ENV SOLR_SRC /app/solr
WORKDIR /app
ADD . ${SOLR_SRC}

# CUDA 8
ENV PATH=/usr/local/cuda/bin:$PATH \
    LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

# Install Sol-R
# https://github.com/favreau/Sol-R
RUN apt-get update && \
    apt-get -y install ${BUILD_TOOLS} && \
    mkdir ${SOLR_SRC}/tmp && \
    cd ${SOLR_SRC}/tmp && \
    wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda_8.0.61_375.26_linux-run && \
    chmod +x cuda_*_linux-run && ${SOLR_SRC}/tmp/cuda_*_linux-run -extract=${SOLR_SRC}/tmp && \
    ${SOLR_SRC}/tmp/cuda-linux64-rel*.run -noprompt | cat > /dev/null && \
    cd ${SOLR_SRC} && \
    rm -rf tmp && \
    mkdir build && \
    cd build && \
    cmake .. \
    -DCMAKE_INSTALL_PREFIX=${DIST_PATH} \
    -DCMAKE_BUILD_TYPE=Release \
    -DSOLR_ENGINE=CUDA && \
    make -j8 install && \
    cd /app && \
    rm -rf ${SOLR_SRC}/build && \
    apt-get -y remove ${BUILD_TOOLS} && \
    apt-get clean

# Add binaries from dist to the PATH
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:${DIST_PATH}/lib
ENV PATH $PATH:${DIST_PATH}/bin

# When running `docker run -ti --rm sol-r`,
# this will be the cmd that will be executed (+ the CLI options from CMD).
# To ssh into the container (or override the default entry) use:
# `docker run -ti --rm --entrypoint bash sol-r`
# See https://docs.docker.com/engine/reference/run/#entrypoint-default-command-to-execute-at-runtime
# for more docs
ENTRYPOINT ["solrViewer"]
