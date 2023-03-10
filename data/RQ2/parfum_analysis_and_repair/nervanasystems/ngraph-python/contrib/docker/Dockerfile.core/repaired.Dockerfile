FROM ngraph_base

# install dependencies
# python-dev and python-pip are installed in ngraph_base image
# for the appropriate python2 or python3 version
WORKDIR /root
RUN apt-get update && \
    apt-get install --no-install-recommends -y cmake && \
    apt-get clean autoclean && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/*;

# install aeon dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y clang libcurl4-openssl-dev libopencv-dev libsox-dev libgtest-dev && \
    apt-get clean autoclean && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/*;

# install ONNX dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y protobuf-compiler libprotobuf-dev && \
    apt-get clean autoclean && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/gtest
RUN cmake CMakeLists.txt
RUN make
RUN cp *.a /usr/local/lib

WORKDIR /root/ngraph-test
ADD contrib/docker/private-aeon /root/private-aeon
WORKDIR /root/private-aeon
RUN pip install --no-cache-dir -r requirements.txt
RUN mkdir -p build && cd build && cmake .. && pip install --no-cache-dir . && cd ..

WORKDIR /root/ngraph-test
ADD . /root/ngraph-test

# add in autoflex.  This should will only be added if the user building
# this dockerfile has permission to access the autoflex repo.  This is a
# temporary solution to get things working quickly.
WORKDIR /root/ngraph-test
ADD contrib/docker/autoflex /root/autoflex
RUN pip install --no-cache-dir -e /root/autoflex

ADD tests/config/jupyter_nbconvert_config.py /root/.jupyter/jupyter_nbconvert_config.py

WORKDIR /root/ngraph-test
