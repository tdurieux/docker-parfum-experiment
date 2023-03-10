FROM nvidia/cuda:11.4.2-devel-ubuntu20.04

RUN apt update && apt install --no-install-recommends -y \
    git python3-pip swig && rm -rf /var/lib/apt/lists/*;

# Checkout GeNN
RUN git clone https://github.com/genn-team/genn.git
WORKDIR /genn

# Setup env
ENV CUDA_PATH=/usr/local/cuda
ENV PATH=$PATH:$CUDA_PATH/bin
ENV PATH=$PATH:/genn/bin

# Install PyGeNN
RUN env
RUN make DYNAMIC=1 LIBRARY_DIRECTORY=/genn/pygenn/genn_wrapper -j 4
RUN pip3 install --no-cache-dir numpy pandas matplotlib
RUN python3 setup.py develop

