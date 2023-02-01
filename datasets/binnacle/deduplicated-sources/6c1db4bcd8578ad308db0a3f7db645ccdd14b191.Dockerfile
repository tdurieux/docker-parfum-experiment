FROM ngraph_test_cpu

# install mkl-dnn
WORKDIR /root
RUN apt-get install -y cmake
RUN apt-get install -y doxygen
RUN apt-get install -y wget
RUN which wget
RUN git clone https://github.com/01org/mkl-dnn.git
WORKDIR mkl-dnn
RUN cd scripts && ./prepare_mkl.sh && cd ..
RUN mkdir -p build && cd build && cmake .. && make
WORKDIR build
RUN make install

# set environment to build mkldnn_engine.so and run with mkldnn_engine
# setup with `pip install -e .`
ENV MKLDNN_ROOT /usr/local
ENV LD_LIBRARY_PATH $MKLDNN_ROOT/lib:$LD_LIBRARY_PATH
WORKDIR /root/ngraph-test
ADD . /root/ngraph-test
RUN make install
RUN make test_prepare 
