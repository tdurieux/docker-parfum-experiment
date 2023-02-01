FROM ubuntu:latest

# Install build dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt --no-install-recommends install -y tzdata && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    cmake && rm -rf /var/lib/apt/lists/*;

# clone latest from Io repository into src/io
WORKDIR /src
RUN git clone --recursive https://github.com/IoLanguage/io.git

# build and install Io
WORKDIR /src/io
RUN mkdir build
WORKDIR /src/io/build
RUN cmake ..
RUN make
RUN make install

ENTRYPOINT [ "bash" ]