FROM ubuntu:16.04

# Install
RUN apt-get -qq update
RUN apt-get install --no-install-recommends -y cmake g++ && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libboost-all-dev libopenblas-dev opencl-headers ocl-icd-libopencl1 ocl-icd-opencl-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y qt5-default qt5-qmake && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /src/gpu/
RUN mkdir -p /src/cpu/
COPY . /src/

# GPU build
WORKDIR /src/gpu/
RUN CXX=g++ CC=gcc cmake ..
RUN cmake --build . --target leelaz --config Release -- -j2

# CPU build
WORKDIR /src/cpu/
RUN CXX=g++ CC=gcc cmake -DFEATURE_USE_CPU_ONLY=1 ..
RUN cmake --build . --config Release -- -j2
RUN ./tests
