ARG REGISTRY
ARG CODE_VERSION
ARG RPC_VERSION
FROM ${REGISTRY}/${RPC_VERSION}-rpc:${CODE_VERSION}

LABEL maintainer="Dan Crankshaw <dscrankshaw@gmail.com>"

RUN apt-get update -qq && apt-get install -y -qq --no-install-recommends \
       build-essential cmake git libgoogle-glog-dev libgtest-dev libiomp-dev libleveldb-dev \
       liblmdb-dev libopencv-dev libsnappy-dev libprotobuf-dev \
       protobuf-compiler python-dev libgflags-dev && pip install --no-cache-dir -q future==0.16.* protobuf==3.5.* && rm -rf /var/lib/apt/lists/*;

RUN git clone --recursive https://github.com/pytorch/pytorch.git \
	&& cd pytorch \
	&& git submodule update --init \
	&& mkdir build \
	&& cd build \
	&& cmake .. -DUSE_MPI=OFF \
    && make -j8 install

ENV LD_LIBRARY_PATH=/usr/local/lib/

RUN cd ~ && python -c 'from caffe2.python import core'

RUN pip install --no-cache-dir -q onnx
RUN python -c "import onnx"

COPY containers/python/caffe2_onnx_container.py containers/python/container_entry.sh /container/

CMD ["/container/container_entry.sh", "caffe2-onnx", "/container/caffe2_onnx_container.py"]

# vim: set filetype=dockerfile:
