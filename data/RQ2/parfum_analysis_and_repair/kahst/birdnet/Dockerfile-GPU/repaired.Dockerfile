# Install NVIDIA GPU image
FROM nvidia/cuda:9.2-cudnn7-devel

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends python3-dev python3-pip python3-nose python3-setuptools libblas-dev liblapack-dev cmake ffmpeg gfortran git && rm -rf /var/lib/apt/lists/*

# Install required Python packages
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir numpy scipy cython librosa future

# Obtain libgpuarray  & pygpu.
RUN git clone https://github.com/Theano/libgpuarray.git

# Build and Install libgpuarray & pygpu.
RUN cd libgpuarray && \
    mkdir Build && \
    cd Build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    make && \
    make install && \
    cd .. && \
    python3 setup.py build && \
    python3 setup.py install && \
    ldconfig

# Install Theano
RUN git clone git://github.com/Theano/Theano.git && \
    cd Theano && \
    pip3 install --no-cache-dir -e .

ENV THEANO_FLAGS 'device=cuda,floatX=float32'
# FP32 is used by default. You can always reset this flag.

# Set up .theanorc for CUDA
RUN echo "[global]\ndevice=cuda\nfloatX=float32\noptimizer_including=cudnn\n[lib]\ncnmem=0.1\n[nvcc]\nfastmath=True" > /root/.theanorc

# Install Lasagne
RUN pip3 install --no-cache-dir https://github.com/Lasagne/Lasagne/archive/master.zip

# Import all scripts
COPY . ./

# Fetch model
ADD https://tuc.cloud/index.php/s/m9smX4FkqmJaxLW/download ./model/BirdNET_Soundscape_Model.pkl

# Add entry point to run the script
ENTRYPOINT [ "python3", "./analyze.py" ]