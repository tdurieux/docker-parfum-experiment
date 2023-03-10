FROM ubuntu:xenial

# Install utilities
RUN apt-get update --fix-missing && apt-get -y upgrade && \
 apt-get install --no-install-recommends -y build-essential cmake ocl-icd-opencl-dev libuv1-dev libmicrohttpd-dev && rm -rf /var/lib/apt/lists/*;

# Copy files
COPY src /src/
COPY res /res/
COPY cmake /cmake/
COPY build.sh /
COPY CMakeLists.txt /
RUN chmod +x build.sh

RUN sh build.sh
