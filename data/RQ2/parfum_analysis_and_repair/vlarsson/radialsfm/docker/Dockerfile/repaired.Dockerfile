FROM nvidia/cuda:10.2-devel-ubuntu18.04

# Prepare and empty machine for building
RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    cmake \
    vim \
    build-essential \
    libboost-program-options-dev \
    libboost-filesystem-dev \
    libboost-graph-dev \
    libboost-system-dev \
    libboost-test-dev \
    libeigen3-dev \
    libsuitesparse-dev \
    libfreeimage-dev \
    libgoogle-glog-dev \
    libgflags-dev \
    libglew-dev \
    qtbase5-dev \
    libqt5opengl5-dev \
    libcgal-dev \
    libcgal-qt5-dev && rm -rf /var/lib/apt/lists/*;

# Build and install ceres solver
RUN apt-get -y --no-install-recommends install \
    libatlas-base-dev \
    libsuitesparse-dev && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/ceres-solver/ceres-solver.git --branch 1.14.0
RUN cd ceres-solver && \
	mkdir build && \
	cd build && \
	cmake .. -DBUILD_TESTING=OFF -DBUILD_EXAMPLES=OFF && \
	make -j4 && \
	make install

# Build and install COLMAP

# Note: This Dockerfile has been tested using COLMAP pre-release 3.6.
# Later versions of COLMAP (which will be automatically cloned as default) may
# have problems using the environment described thus far. If you encounter
# problems and want to install the tested release, then uncomment the branch
# specification in the line below
RUN git clone https://github.com/colmap/colmap.git #--branch 3.6

RUN cd colmap && \
	git checkout dev && \
	mkdir build && \
	cd build && \
	cmake .. && \
	make -j4 && \
	make install
