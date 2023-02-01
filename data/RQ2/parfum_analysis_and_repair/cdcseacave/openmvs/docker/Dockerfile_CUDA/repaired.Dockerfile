FROM nvidia/cuda:11.1-devel-ubuntu18.04

ARG USER_ID
ARG GROUP_ID

# Initialize the environment
RUN apt update
RUN apt install --no-install-recommends -y cmake git vim && rm -rf /var/lib/apt/lists/*;

# Prepare and empty machine for building:
RUN apt-get update -yq
RUN apt-get install -yq
RUN apt-get -y --no-install-recommends install git mercurial cmake libpng-dev libjpeg-dev libtiff-dev libglu1-mesa-dev && rm -rf /var/lib/apt/lists/*;

ENV PATH=/usr/local/cuda-11.1/bin:$PATH

# Eigen
RUN git clone https://gitlab.com/libeigen/eigen --branch 3.4
RUN mkdir eigen_build
RUN cd eigen_build &&\
	cmake . ../eigen -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda/ &&\
	make && make install &&\
	cd ..

# Boost
RUN apt-get -y --no-install-recommends install libboost-iostreams-dev libboost-program-options-dev libboost-system-dev libboost-serialization-dev && rm -rf /var/lib/apt/lists/*;

# OpenCV
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -yq libopencv-dev && rm -rf /var/lib/apt/lists/*;

# CGAL
RUN apt-get -y --no-install-recommends install libcgal-dev libcgal-qt5-dev && rm -rf /var/lib/apt/lists/*;

# VCGLib
RUN git clone https://github.com/cdcseacave/VCG.git vcglib

# Build from stable openMVS release
RUN git clone https://github.com/cdcseacave/openMVS.git --branch master

# Uncomment below (and comment above) to use the latest commit from the develop branch
#RUN git clone https://github.com/cdcseacave/openMVS.git --branch develop

RUN mkdir openMVS_build
RUN cd openMVS_build &&\
	cmake . ../openMVS -DCMAKE_BUILD_TYPE=Release -DVCG_ROOT=/vcglib -DOpenMVS_USE_CUDA=ON -DCMAKE_LIBRARY_PATH=/usr/local/cuda/lib64/stubs/ -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-11.1/ -DCUDA_INCLUDE_DIRS=/usr/local/cuda-11.1/include/ -DCUDA_CUDART_LIBRARY=/usr/local/cuda-11.1/lib64 -DCUDA_NVCC_EXECUTABLE=/usr/local/cuda-11.1/bin/

# Install OpenMVS library
RUN cd openMVS_build &&\
	make -j4 &&\
	make install

# Set permissions such that the output files can be accessed by the current user (optional)
RUN addgroup --gid $GROUP_ID user
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user
USER user

# Add binaries to path
ENV PATH /usr/local/bin/OpenMVS:$PATH
