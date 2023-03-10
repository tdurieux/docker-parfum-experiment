FROM ubuntu:16.04
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential software-properties-common \
    libboost-dev libboost-serialization-dev libssl-dev \
    cmake vim \
    wget \
    make libbz2-dev libexpat1-dev swig python-dev && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:ubuntugis/ppa && apt-get -q update
RUN apt-get -y --no-install-recommends install gdal-bin libgdal-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /fmm
COPY . /fmm
WORKDIR /fmm
RUN rm -rf build
RUN mkdir -p build && \
    cd build && \
    cmake .. && \
    make install
EXPOSE 8080
CMD
