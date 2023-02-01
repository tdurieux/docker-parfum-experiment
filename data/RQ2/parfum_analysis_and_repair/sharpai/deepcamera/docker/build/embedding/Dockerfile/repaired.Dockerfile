FROM shareai/tensorflow:armv7l_tf1.8

RUN mkdir -p /root/.ssh
COPY ./id_rsa /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa
COPY ./sshconfig /root/.ssh/config

RUN ls -lh && apt-get update && apt-get install --no-install-recommends -y libopenblas-base && apt-get clean && \
    mkdir -p /root/.local/lib/python2.7/site-packages/ && rm -rf /var/lib/apt/lists/*;

COPY ./requirements.txt /root/requirements.txt
RUN pip install --no-cache-dir -r /root/requirements.txt

RUN apt-get -y --no-install-recommends install clang && rm -rf /var/lib/apt/lists/*;

ENV CC=clang
ENV CXX=clang++
RUN git clone https://github.com/apache/incubator-mxnet.git -b 1.2.0 --recursive
RUN apt-get install --no-install-recommends -y git unzip cmake build-essential libopenblas* && rm -rf /var/lib/apt/lists/*; #liblapack* libblas*
#RUN apt-get install -y google-perftools
RUN apt-get install --no-install-recommends -y --reinstall pkg-config cmake-data && rm -rf /var/lib/apt/lists/*;
COPY assets/Makefile /incubator-mxnet/Makefile
COPY assets/CMakeLists.txt /incubator-mxnet/CMakeLists.txt
RUN mv incubator-mxnet mxnet && \
    cd mxnet && \
    mkdir build && \
    cd build && \
    cmake -DUSE_SSE=OFF \
        -DUSE_F16C=OFF \
        -DUSE_CUDA=OFF \
        -DUSE_OPENCV=OFF \
        -DUSE_OPENMP=OFF \
        -DUSE_GPERFTOOLS=OFF \
        -DUSE_JEMALLOC=OFF \
        -DUSE_MKL_IF_AVAILABLE=OFF \
        -DUSE_SIGNAL_HANDLER=ON \
        -DADD_CFLAGS=-fPIC \
        -DUSE_CPP_PACKAGE=OFF \
        -Dmxnet_LINKER_LIBS=-latomic \
        -DBUILD_CPP_EXAMPLES=OFF \
        -DCMAKE_BUILD_TYPE=Release ..
#WORKDIR /root/mxnet/build
RUN pwd && ls -alh
RUN cd mxnet/build && \
    make -v -j4 && \
    make install
COPY assets/setup.py /mxnet/python/
RUN cd /mxnet && \
    make cython PYTHON=python && \
    cd /mxnet/python && \
    pip install --no-cache-dir -e .
