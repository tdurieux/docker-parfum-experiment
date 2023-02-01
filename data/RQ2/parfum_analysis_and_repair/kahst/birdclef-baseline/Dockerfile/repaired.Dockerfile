FROM nvidia/cuda:9.1-cudnn7-devel

RUN apt-get update && apt-get install -y --no-install-recommends python-dev python-pip libblas-dev liblapack-dev cmake python-opencv libav-tools gfortran git python-numpy python-scipy python-nose python-setuptools && rm -rf /var/lib/apt/lists/*

# Set CUDA_ROOT
#ENV CUDA_ROOT /usr/local/cuda/bin

# Install Cython
RUN pip install --no-cache-dir Cython

# Clone libgpuarray repo and move into it
RUN cd /root && git clone https://github.com/Theano/libgpuarray.git && cd libgpuarray && \
# Make and move into build directory
  mkdir Build && cd Build && \
# CMake
  cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr && \
# Make
  make -j"$(nproc)" && \
  make install
# Install pygpu
RUN cd /root/libgpuarray && \
  python setup.py build_ext -L /usr/lib -I /usr/include && \
  python setup.py install

# Install bleeding-edge Theano
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir --upgrade six && pip install --no-cache-dir --upgrade --no-deps git+git://github.com/Theano/Theano.git
# Set up .theanorc for CUDA
COPY .theanorc /root/.theanorc

# Install Lasagne
RUN pip install --no-cache-dir https://github.com/Lasagne/Lasagne/archive/master.zip

# Now this!
VOLUME /birdclef/datasets

WORKDIR /birdclef

COPY . ./

RUN pip install --no-cache-dir -r requirements.txt

CMD ["bash", "run.sh"]