FROM billion-scale-benchmark

RUN apt-get update && apt-get install --no-install-recommends -y wget git cmake g++ libaio-dev libgoogle-perftools-dev libboost-dev python3 python3-setuptools python3-pip libomp-dev && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir pybind11 numpy

RUN mkdir -p BBAnn
COPY include BBAnn/include
COPY python/*.py BBAnn/python/
COPY python/*.cpp BBAnn/python/
COPY src BBAnn/src
COPY CMakeLists.txt BBAnn/
RUN ls BBAnn

RUN mkdir -p BBAnn/build
RUN cd BBAnn/build && cmake -DCMAKE_BUILD_TYPE=Release ..
RUN cd BBAnn/build && make -j
RUN cd BBAnn/python && pip install --no-cache-dir -e .
RUN python3 -c 'import bbannpy'
