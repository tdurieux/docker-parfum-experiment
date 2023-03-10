FROM python:3.6
WORKDIR /root/
ARG BRANCH="master"
ARG NUM_CORES=2

RUN echo "deb http://ftp.us.debian.org/debian unstable main contrib non-free" >> /etc/apt/sources.list.d/unstable.list &&\
    apt-get update && apt-get install --no-install-recommends -y \
    gcc \
    g++ \
    git \
    cmake \
    libgmp-dev \
    libmpfr-dev \
    libgmpxx4ldbl \
    libboost-dev \
    libboost-thread-dev \
    zip unzip patchelf && \
    apt-get clean && \
    git clone --single-branch -b $BRANCH https://github.com/PyMesh/PyMesh.git && rm -rf /var/lib/apt/lists/*;

ENV PYMESH_PATH /root/PyMesh
ENV NUM_CORES $NUM_CORES
WORKDIR $PYMESH_PATH

RUN git submodule update --init && \
    pip install --no-cache-dir -r $PYMESH_PATH/python/requirements.txt && \
    ./setup.py bdist_wheel && \
    rm -rf build_3.6 third_party/build && \
    python $PYMESH_PATH/docker/patches/patch_wheel.py dist/pymesh2*.whl && \
    pip install --no-cache-dir dist/pymesh2*.whl && \
    python -c "import pymesh; pymesh.test()"
