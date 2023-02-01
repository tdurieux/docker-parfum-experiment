ARG PlatformRelease
FROM $PlatformRelease
ENV container docker
LABEL maintainer="Flavio Bergamaschi <flavio@uk.ibm.com>"

ARG USER_ID
# Docker Container for Ubuntu HElib Base

USER root

# Setup the toolchain
RUN apt update

# set noninteractive installation
RUN export DEBIAN_FRONTEND=noninteractive

# Update the base OS
RUN DEBIAN_FRONTEND=noninteractive apt update
RUN DEBIAN_FRONTEND=noninteractive apt dist-upgrade -y

# Install Doxygen so we can build the docs inside the container
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
    doxygen && rm -rf /var/lib/apt/lists/*;

# Install tzdata package
RUN DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y tzdata && rm -rf /var/lib/apt/lists/*;
# Set UTC timezone
RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

# Install the compilation toolchain we need...
RUN DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y \
    xz-utils \
    curl \
    wget \
    build-essential \
    git \
    cmake \
    m4 \
    file \
    patchelf \
    vim && rm -rf /var/lib/apt/lists/*;

# Install bats-core
RUN git clone https://github.com/bats-core/bats-core.git && \
    cd bats-core && \
    ./install.sh /usr/local

# Install GMP dependency for NTL
RUN DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y libgmp-dev && rm -rf /var/lib/apt/lists/*;

# Install HDF5 dependency for FHE ML library
RUN DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y libhdf5-dev libhdf5-103 && rm -rf /var/lib/apt/lists/*;

# Cleanup unnecessary and downloaded packages (.deb) during installation
RUN DEBIAN_FRONTEND=noninteractive apt autoremove -y
RUN DEBIAN_FRONTEND=noninteractive apt autoclean -y

# Create dependencies build environment.
RUN mkdir -p /opt/IBM/FHE-distro

# Download, build and install NTL as system library in /usr/local
COPY ./DEPENDENCIES/NTL                /opt/IBM/FHE-distro/NTL
WORKDIR /opt/IBM/FHE-distro/NTL
RUN cd ./src && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" SHARED=on NTL_GMP_LIP=on NTL_THREADS=on NTL_THREAD_BOOST=on NTL_RANDOM_AES256CTR=on && \
    make -j4 && \
    make install && \
    ldconfig && \
    cd ../.. && \
    rm -rf NTL

# Download, build and install HElib as system library in /usr/local
COPY ./DEPENDENCIES/HElib              /opt/IBM/FHE-distro/HElib
WORKDIR /opt/IBM/FHE-distro/HElib
RUN  mkdir ./build && \
    cd ./build && \
    cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DBUILD_SHARED=ON -DENABLE_THREADS=ON .. && \
    make -j4 && \
    make install && \
    ldconfig

#Generate the docs of HElib from their source
WORKDIR /opt/IBM/FHE-distro/HElib/documentation
RUN doxygen Doxyfile

# Download, build and install Boost as system library in /usr/local
COPY ./DEPENDENCIES/boost              /opt/IBM/FHE-distro/boost
WORKDIR /opt/IBM/FHE-distro/boost
RUN ./bootstrap.sh --with-libraries=filesystem,system,thread && \
    ./b2 -d0 -j4 install && \
    ldconfig && \
    cd .. && \
    rm -rf boost


# Build and install ML-HElib as system library in /usr/local
COPY ./DEPENDENCIES/ML-HElib    /opt/IBM/FHE-distro/ML-HElib
WORKDIR /opt/IBM/FHE-distro/ML-HElib
RUN /bin/bash ./install_system_wide.sh && \
    ldconfig

#Generate the docs of ML-HElib from their source
WORKDIR /opt/IBM/FHE-distro/ML-HElib/documentation
RUN doxygen Doxyfile

# Create user fhe:fhe with no login,
RUN adduser --uid ${USER_ID}  --gecos "FHE Toolkit User" --disabled-login fhe

WORKDIR /home/fhe
USER fhe
RUN mkdir -p /home/fhe/FHE_Examples
RUN cp -pr /opt/IBM/FHE-distro/HElib/examples/. /home/fhe/FHE_Examples


CMD ["/usr/bin/bash"]
