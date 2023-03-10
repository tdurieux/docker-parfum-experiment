FROM ubuntu:18.04
USER root
ARG PPM_CONFIG_FILE
ARG PPM_MAP_FILE

WORKDIR /cvdi-stream

# Add build tools.
RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common wget git make gcc-7 g++-7 gcc-7-base && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 100 && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 100 && rm -rf /var/lib/apt/lists/*;

# Install cmake.
RUN wget https://cmake.org/files/v3.7/cmake-3.7.2.tar.gz && tar -xvf cmake-3.7.2.tar.gz && rm cmake-3.7.2.tar.gz
RUN cd cmake-3.7.2 && ./bootstrap && make && make install && cd /

# Install librdkafka.
RUN git clone https://github.com/edenhill/librdkafka.git && cd librdkafka && ln -s /usr/bin/python3 /usr/bin/python && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install && cd /cvdi-stream

# add the source and build files
ADD CMakeLists.txt /cvdi-stream
ADD ./src /cvdi-stream/src
ADD ./cv-lib /cvdi-stream/cv-lib
ADD ./include /cvdi-stream/include
ADD ./kafka-test /cvdi-stream/kafka-test
ADD ./unit-test-data /cvdi-stream/unit-test-data
ADD config/${PPM_CONFIG_FILE} /cvdi-stream/config/
ADD data/${PPM_MAP_FILE} /cvdi-stream/config/

# Do the build.
RUN export LD_LIBRARY_PATH=/usr/local/lib && mkdir /cvdi-stream-build && cd /cvdi-stream-build && cmake /cvdi-stream && make

# Add test data. This changes frequently so keep it low in the file.
ADD ./docker-test /cvdi-stream/docker-test

# Run the tool.
CMD ["/cvdi-stream/docker-test/ppm-nsv.sh"]
