FROM ossrs/srs:dev-gcc7

# Install depends tools.
RUN yum install -y gcc make gcc-c++ patch unzip perl git && rm -rf /var/cache/yum

# Build and install SRS.
COPY . /srs
WORKDIR /srs/trunk

# Note that we must enable the gcc7 or link failed.
RUN scl enable devtoolset-7 -- ./configure --srt=on --utest=on --jobs=2
RUN scl enable devtoolset-7 -- make -j2 utest

# Build benchmark tool.
RUN cd 3rdparty/srs-bench && make

# Run utest
RUN ./objs/srs_utest
