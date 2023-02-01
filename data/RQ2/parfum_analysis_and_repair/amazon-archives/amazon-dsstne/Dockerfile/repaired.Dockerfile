# VERSION 0.3
# AUTHOR:         DSSTNE Docker <dsstne-docker@amazon.com>
# DESCRIPTION:    Docker image for Amazon DSSTNE

FROM nvidia/cuda:9.1-cudnn7-devel-ubuntu16.04

# Suppress interactive prompts while installing base packages
ENV DEBIAN_FRONTEND=noninteractive

# Add repositories and install base packages
RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential libcppunit-dev libatlas-base-dev pkg-config python \
        software-properties-common unzip wget && \
    add-apt-repository ppa:george-edison55/cmake-3.x && \
    apt-get update && \
    apt-get install --no-install-recommends -y cmake && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

# Install OpenMPI
RUN apt-get install --no-install-recommends -y libopenmpi-dev && rm -rf /var/lib/apt/lists/*;

# Install JSONCPP
RUN apt-get install --no-install-recommends -y libjsoncpp-dev && rm -rf /var/lib/apt/lists/*;

# Install hdf5
RUN apt-get install --no-install-recommends -y libhdf5-dev && rm -rf /var/lib/apt/lists/*;

# Install zlib
RUN apt-get install --no-install-recommends -y zlib1g-dev && rm -rf /var/lib/apt/lists/*;

# Install netcdf
RUN apt-get install --no-install-recommends -y libnetcdf-dev && rm -rf /var/lib/apt/lists/*;

# Install netcdf-c++
RUN apt-get install --no-install-recommends -y libnetcdf-c++4-dev && rm -rf /var/lib/apt/lists/*;

# Installing CUBG
RUN cd /tmp && \
    wget https://github.com/NVlabs/cub/archive/1.5.2.zip && \
    unzip 1.5.2.zip && \
    cp -rf cub-1.5.2/cub/ /usr/local/include/ && \
    rm -rf /tmp/*

# Ensure OpenMPI is available on path
ENV PATH=/usr/local/openmpi/bin/:${PATH} \
    LD_LIBRARY_PATH=/usr/local/lib/:/usr/local/openmpi/lib/:${LD_LIBRARY_PATH}

# Build latest version of DSSTNE from source
COPY . /opt/amazon/dsstne
RUN cd /opt/amazon/dsstne && \
    make install

# Cleanup
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add DSSTNE binaries to PATH
ENV PATH=/opt/amazon/dsstne/bin/:${PATH}
