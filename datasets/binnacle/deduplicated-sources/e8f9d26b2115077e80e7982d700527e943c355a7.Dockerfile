FROM ngraph_base_cpu

# install dependencies
# python-dev and python-pip are installed in ngraph_base_cpu image
# for the appropriate python2 or python3 version
WORKDIR /root
RUN apt-get update && \
    apt-get install -y cmake && \
    apt-get clean autoclean && \
    apt-get autoremove -y

# install aeon dependencies
RUN apt-get update && \
    apt-get install -y clang libcurl4-openssl-dev libopencv-dev libsox-dev libgtest-dev && \
    apt-get clean autoclean && \
    apt-get autoremove -y

# install ONNX dependencies
RUN apt-get update && \
    apt-get install -y protobuf-compiler libprotobuf-dev && \
    apt-get clean autoclean && \
    apt-get autoremove -y

WORKDIR /usr/src/gtest
RUN cmake CMakeLists.txt
RUN make
RUN cp *.a /usr/local/lib

WORKDIR /root/ngraph-test
ADD contrib/docker/private-aeon /root/private-aeon
WORKDIR /root/private-aeon
RUN pip install -r requirements.txt
RUN mkdir -p build && cd build && cmake .. && pip install . && cd ..

# build Baidu's Warp-CTC
# dependencies for deepspeech example
WORKDIR /root
RUN git clone https://github.com/baidu-research/warp-ctc.git
RUN cd warp-ctc
ADD . /root/warp-ctc
WORKDIR /root/warp-ctc
RUN mkdir -p build
RUN cd build && cmake ../ && make && cd ../..
ENV WARP_CTC_PATH=/root/warp-ctc/build
ENV WARP_CTC_LIB=$WARP_CTC_PATH/libwarpctc.so
ENV LD_LIBRARY_PATH=$WARP_CTC_PATH:$LD_LIBRARY_PATH
RUN env
RUN ls -l $WARP_CTC_PATH

WORKDIR /root/ngraph-test
ADD test_requirements.txt /root/ngraph-test/test_requirements.txt
RUN pip install -r test_requirements.txt
ADD examples_requirements.txt /root/ngraph-test/examples_requirements.txt
RUN pip install -r examples_requirements.txt


# add chown_files script
WORKDIR /root/ngraph-test
ADD contrib/docker/chown_files.sh /tmp/chown_files.sh

# necessary for tests/test_walkthrough.py which requires that ngraph is
# importable from an entrypoint not local to ngraph.
ADD . /root/ngraph-test
RUN make install
RUN make test_prepare

WORKDIR /root/ngraph-test
ADD tests/config/jupyter_nbconvert_config.py /root/.jupyter/jupyter_nbconvert_config.py

