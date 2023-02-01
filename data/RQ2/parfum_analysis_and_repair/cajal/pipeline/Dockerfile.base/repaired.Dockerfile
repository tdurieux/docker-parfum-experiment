FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04

LABEL maintainer="Erick Cobos <ecobos@bcm.edu>, Donnie Kim <donniek@bcm.edu>"
ARG DEBIAN_FRONTEND=noninteractive

###############################################################################
# Install some optimization libraries (used by many libraries below)
RUN apt-get update && \
    apt-get install --no-install-recommends -y libopenblas-dev libatlas-base-dev libeigen3-dev libssl-dev libffi-dev libbz2-dev && \
    export MKL_NUM_THREADS=1 OPENBLAS_NUM_THREADS=1 OMP_NUM_THREADS=1 && rm -rf /var/lib/apt/lists/*;



###############################################################################
# Install Python 3

RUN apt-get update && \
    apt-get install --no-install-recommends -y --upgrade python3.8 python3.8-dev python3-pip python3-numpy python3-scipy \
        python3-matplotlib && rm -rf /var/lib/apt/lists/*;


RUN pip3 install --no-cache-dir --upgrade pip



###############################################################################
# Instal FFTW (C library) and pyfftw (its python wrapper)
RUN apt-get install -y --no-install-recommends tar && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y wget && \
    wget https://www.fftw.org/fftw-3.3.8.tar.gz && \
    tar -xvzf fftw-3.3.8.tar.gz && \
    cd fftw-3.3.8 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-threads --with-pic --enable-float --enable-sse --enable-sse2 --enable-avx && \
    make && \
    make install && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-threads --with-pic --enable-sse2 -enable-avx && \
    make && \
    make install && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-threads --with-pic --enable-long-double && \
    make && \
    make install && \
    cd .. && \
    rm fftw-3.3.8.tar.gz && \
    rm -r fftw-3.3.8 && \
    pip3 install --no-cache-dir pyfftw && rm -rf /var/lib/apt/lists/*;

###############################################################################
# Install CaImAn
# Install dependencies.
RUN apt-get install --no-install-recommends -y git python3-tk && \
    pip3 install --no-cache-dir future cvxpy scikit-learn==0.21.3 scikit-image==0.16.2 tensorflow==1.14 keras==2.3.1 \
                 peakutils \

                 ipyparallel Cython h5py==2.10.0 tqdm psutil && rm -rf /var/lib/apt/lists/*;

# Install without OASIS
RUN pip3 install --no-cache-dir git+https://github.com/atlab/CaImAn.git

###############################################################################
# Install spike deconvolution packages
RUN pip3 install --no-cache-dir git+https://github.com/cajal/PyFNND# oopsie

RUN apt-get install --no-install-recommends -y autoconf automake libtool && \
    git clone https://github.com/lucastheis/cmt.git && \
    cd cmt/code/liblbfgs && \
    ./autogen.sh && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-sse2 && \
    make CFLAGS="-fPIC" && \
    cd ../.. && \
    python3 setup.py build && \
    python3 setup.py install && \
    python3 setup.py clean --all && \
    cd .. && \
    rm -r cmt && \
    pip3 install --no-cache-dir git+https://github.com/cajal/c2s.git && rm -rf /var/lib/apt/lists/*; # stm (spike-triggered mixture model)

###############################################################################
# install Deeplabcut and its dependencies
RUN pip3 install --no-cache-dir git+https://github.com/cajal/DeepLabCut.git

###############################################################################
# Install pytorch
RUN pip3 install --no-cache-dir torch==0.4.1 && \
    pip3 install --no-cache-dir torchvision

###############################################################################
# Miscelaneous packages
RUN pip3 install --no-cache-dir git+https://github.com/atlab/datajoint-python.git && \
    pip3 install --no-cache-dir git+https://github.com/atlab/scanreader.git && \
    pip3 install --no-cache-dir git+https://github.com/cajal/bl3d.git && \
    pip3 install --no-cache-dir seaborn slacker imreg_dft pandas imageio
RUN apt-get update && \
    apt-get install --no-install-recommends -y python3-git ffmpeg && rm -rf /var/lib/apt/lists/*;

# Optional
RUN apt-get install --no-install-recommends -y nano vim graphviz && \
    pip3 install --no-cache-dir nose2 jupyterlab && rm -rf /var/lib/apt/lists/*;

# Install commons
RUN git clone https://github.com/atlab/commons.git && \
    pip3 install --no-cache-dir commons/python && \
    rm -r commons


ENTRYPOINT ["/bin/bash"]
