FROM buildpack-deps:jessie

# Download sources
RUN cd /opt && curl -f -LO http://fallabs.com/kyotocabinet/pkg/kyotocabinet-1.2.76.tar.gz
RUN cd /opt && tar -xvzf kyotocabinet-1.2.76.tar.gz && mv kyotocabinet-1.2.76 kyotocabinet && rm kyotocabinet-1.2.76.tar.gz
RUN apt-get update

# Install clang
RUN apt-get install --no-install-recommends -y clang && rm -rf /var/lib/apt/lists/*;
ENV C clang
ENV CXX clang++

# Install kyoto cabinet
RUN apt-get -y --no-install-recommends install liblzo2-dev liblzma-dev zlib1g-dev build-essential && rm -rf /var/lib/apt/lists/*;
RUN cd /opt/kyotocabinet && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" –enable-zlib – nable-lzo –en ble-lzma && ma e & ma e nstall

# install raptor2
RUN apt-get install --no-install-recommends -y libraptor2-dev && rm -rf /var/lib/apt/lists/*;

# Install Serd
RUN apt-get install --no-install-recommends -y libserd-dev && rm -rf /var/lib/apt/lists/*;

# Install CMake
RUN curl -f -sSL https://cmake.org/files/v3.5/cmake-3.5.2-Linux-x86_64.tar.gz | tar -xzC /opt
ENV PATH /opt/cmake-3.5.2-Linux-x86_64/bin/:$PATH

# Install GDB for debugging
RUN apt-get install --no-install-recommends -y gdb && rm -rf /var/lib/apt/lists/*;

# Copy sources
COPY deps /opt/ostrich/deps
COPY ext /opt/ostrich/ext
COPY src /opt/ostrich/src
COPY CMakeLists.txt /opt/ostrich/CMakeLists.txt
COPY run.sh /opt/ostrich/run.sh
COPY run-debug.sh /opt/ostrich/run-debug.sh

# Enable optional dependencies in Makefile
RUN cd /opt/ostrich/deps/hdt/hdt-lib && sed -i "s/#KYOTO_SUPPORT=true/KYOTO_SUPPORT=true/" Makefile

RUN mkdir /opt/ostrich/build
RUN cd /opt/ostrich/build && cmake .. -Wno-deprecated
RUN cd /opt/ostrich/build && make

WORKDIR /var/evalrun

# Default command
ENTRYPOINT ["/opt/ostrich/run.sh"]
CMD ["/var/patches", "1", "58", "/var/queries"]
