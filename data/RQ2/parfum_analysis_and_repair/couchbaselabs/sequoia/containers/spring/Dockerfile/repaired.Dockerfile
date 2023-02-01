FROM ubuntu_gcc

RUN apt-get install --no-install-recommends -y python-dev python-pip wget cmake && rm -rf /var/lib/apt/lists/*;

# Install libcouchbase
RUN git clone git://github.com/couchbase/libcouchbase.git && \
    mkdir libcouchbase/build

WORKDIR libcouchbase/build
RUN ../cmake/configure --prefix=/usr && \
      make && \
      make install

WORKDIR /root
RUN pip install --no-cache-dir spring
WORKDIR spring
