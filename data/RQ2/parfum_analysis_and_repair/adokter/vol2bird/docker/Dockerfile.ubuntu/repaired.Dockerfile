FROM ubuntu:20.04
MAINTAINER Adriaan Dokter

# installs using apt-get:
# * libconfuse: library for parsing options
# * libhdf5: HDF5, Hierarchichal Data Format library
# * libgsl: the GNU Scientific Library
# * git, for fetching repositories from Github
# * git-lfs, for fetching large file repositories from Github
# * wget for downloading files, specifically libtorch
# * unzip
# * compiler (gcc, g++, make, cmake, etc)
# * zlib (gzip archiving library)
# * libbz2 (bzip2 archiving library)
# * python
# * numpy
# * proj4 library
# * flexold, otherwise configure script of RSL library does not function properly
RUN apt-get update && apt-get install --no-install-recommends -y libconfuse-dev \
    libhdf5-dev gcc g++ wget unzip make cmake zlib1g-dev python python-dev python-numpy libproj-dev flex-old file \
    && apt-get install --no-install-recommends -y git git-lfs && apt-get install --no-install-recommends -y libgsl-dev && apt-get install --no-install-recommends -y libbz2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3 python3-dev python3-numpy && rm -rf /var/lib/apt/lists/*;
