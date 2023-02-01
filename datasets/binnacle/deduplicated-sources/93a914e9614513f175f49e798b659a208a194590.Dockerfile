FROM debian:jessie

ARG TERM=linux
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update                                          \
    && apt-get install --assume-yes --no-install-recommends \
      bison                                                 \
      ca-certificates                                       \
      cmake                                                 \
      flex                                                  \
      g++                                                   \
      git                                                   \
      libboost-dev                                          \
      libboost-filesystem-dev                               \
      libboost-program-options-dev                          \
      libboost-regex-dev                                    \
      libboost-system-dev                                   \
      libboost-test-dev                                     \
      libpython2.7-dev                                      \
      libssl-dev                                            \
      libtool                                               \
      make                                                  \
      pkg-config                                            \
      python-pip                                            \
    && rm -rf /var/lib/apt/lists/*
RUN pip install \
      cython    \
      pandas


ENV ARROW_SOURCE_PATH=/usr/local/src/arrow         \
    PARQUET_SOURCE_PATH=/usr/local/src/parquet-cpp

ENV ARROW_HOME=/opt/arrow         \
    PARQUET_HOME=/opt/parquet-cpp


##
## arrow
##
WORKDIR /usr/local/src
RUN git clone https://github.com/apache/arrow.git
WORKDIR $ARROW_SOURCE_PATH/cpp
RUN cmake                                \
      -DCMAKE_INSTALL_PREFIX=$ARROW_HOME \
      -DCMAKE_BUILD_TYPE=Release         \
      -DARROW_BUILD_TESTS=Off            \
      .
RUN make -j4
RUN make install


##
## pyarrow
##
WORKDIR $ARROW_SOURCE_PATH/python
RUN pip install -r requirements.txt \
    && python setup.py build_ext    \
      --with-jemalloc               \
      --build-type=release          \
      install


ENV LD_LIBRARY_PATH=$ARROW_HOME/lib:$ARROW_SOURCE_PATH/cpp/jemalloc_ep-prefix/src/jemalloc_ep/dist/lib:$LD_LIBRARY_PATH
WORKDIR /root
COPY example.py .
RUN python example.py -v
