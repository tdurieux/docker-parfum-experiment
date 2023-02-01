FROM nvidia/cuda:10.2-devel-ubuntu18.04

# Install python3, wget, and openblas.
RUN apt-get update && \
        apt-get install --no-install-recommends -y python3-dev python3-pip libopenblas-dev wget libpcre3-dev && rm -rf /var/lib/apt/lists/*;

# Install swig 4.0.2.
RUN wget -nv -O - https://sourceforge.net/projects/swig/files/swig/swig-4.0.2/swig-4.0.2.tar.gz/download | tar zxf - && cd swig-4.0.2 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make -j && make install

# Install recent CMake.
RUN wget -nv -O - https://github.com/Kitware/CMake/releases/download/v3.17.1/cmake-3.17.1-Linux-x86_64.tar.gz | tar xzf - --strip-components=1 -C /usr

# Install numpy/scipy/pytorch for python tests.
RUN pip3 install --no-cache-dir numpy scipy torch

COPY . /faiss

WORKDIR /faiss

RUN cmake -B build \
        -DFAISS_ENABLE_GPU=ON \
        -DFAISS_ENABLE_C_API=ON \
        -DFAISS_ENABLE_PYTHON=ON \
        -DBUILD_TESTING=ON \
        -DCMAKE_CUDA_FLAGS="-gencode arch=compute_75,code=sm_75" \
        .

RUN make -C build -j8
