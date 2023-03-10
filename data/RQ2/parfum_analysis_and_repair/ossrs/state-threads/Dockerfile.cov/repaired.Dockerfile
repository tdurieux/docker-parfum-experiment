FROM ossrs/srs:dev-gcc7

# Install depends tools.
RUN yum install -y gcc make gcc-c++ patch unzip perl git && rm -rf /var/cache/yum

# Build and install SRS.
COPY . /st
WORKDIR /st

# Note that we must enable the gcc7 or link failed.
RUN scl enable devtoolset-7 -- make linux-debug-gcov

