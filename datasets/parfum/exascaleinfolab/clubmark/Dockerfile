# Use the specified base image.
# All evaluating algorithms are built under Ubuntu 16.04
FROM ubuntu:16.04

# Set multiple labels at once, using line-continuation characters to break long lines
# Note: spaces and quotes (") should be either escaped (with '\') or the spaces
# can be taken into quotes
LABEL vendor="eXascale Infolab" \
      info.exascale.clubmark-env.version="3.0" \
      info.exascale.clubmark-env.release-date="2018-06-03" \
	  description="Execution environment ONLY for the Clubmark (former PyCABeM): https://github.com/eXascaleInfolab/PyCABeM/tree/draft"
# Make the working directory an optional build parameter specified by --build-arg
ARG WORK_DIR=/opt/clubmark
# Requirements (dependencies) files for Python3 relative to the $WORKDIR and
# without the directory prefix
ARG PYREQS=pyreqs.txt
# Note: python3 is used to run the benchmark instead of pypy to reduce the number
# of dependencies, because otherwise Python is also required to install the psutil
# via pip on pypy

# Define environment variables
# ATTENTION:
# - ENV overwrites ARG
# - ENV will persist when a container is run from the resulting image
#ENV DEBUG true

# Specify the working directory (created if did not exist)
WORKDIR $WORK_DIR

# Copy required files to the container (relative to the WORKDIR) usin ADD or COPY
# Note ADD (vs COPY):
# - allows <src> to be an URL
# - If the <src> parameter is an archive in a recognized compression format,
#  it will be unpacked: ADD rootfs.tar.xz /
#
# NOTE: during the image build only the copied files can be used, files from the
# external volumes are not available
COPY ./$PYREQS /tmp/$PYREQS

# Install Ubuntu dependencies
# - wget is required to download pip for pypy (and as a useful tool)
# - hwloc (includes lstopo) is required to identify enumeration type of CPUs
#  to perform correct CPU affinity masking
# - Python scripts:  python
# Python2 can be used for all .py files, but it is recommended to use
# Python3 for most of the files (scp.py supports only Python2) and pypy[2]
# for the heavy python apps that do not link C libs (scp, ...)
# - Accessory libraries:
# -- python-igraph:  libxml2-dev zlib1g-dev (Virtual Package: libz-dev)
# - Clustering Algorithms:
# -- ganxis:  openjdk-8-jre  (openjdk >= 7)
# -- rgmc:  libboost-program-options1.58.0
# - Evaluation Apps & Utilities:
# -- gecmi:  libtbb2
# -- remlinks.py: numpy future
RUN apt-get update && apt-get install -y \
	wget \
	hwloc \
	python3 python3-pip pypy \
	libxml2-dev zlib1g-dev \
	openjdk-8-jre \
	libboost-program-options1.58.0 \
	libtbb2

## Install pip to pypy
#RUN set -o pipefail && wget -qO - https://bootstrap.pypa.io/get-pip.py | pypy
#
## Install pypy dependencies (Python2 is required for the compilation)

# Note: Python3 and pip3 were installed on previous step
RUN pip3 install --upgrade pip

# Install Python dependencies
# louvain_igraph.py:  python-igraph
RUN pip3 install -r /tmp/$PYREQS && rm /tmp/$PYREQS

# Make port 8080 available to the world outside this container for the WebUI
EXPOSE 8080

# Run something when the container launches
# ATTENTION: Benchmarking in daemon mode should be run only if the Docker is run
# in the interactive mode, not detached:
# https://docs.docker.com/engine/reference/run/#detached--d
# CMD ["./benchmark_daemon.sh"]
#
# Note:
# - CMD is appended as arguments to the ENTRYPOINT if the latter is specified
#CMD ["bash"]

# Allows you to configure a container that will run as an executable and pass
# arguments to the "benchmark.py"
# Notes:
# - it overrides all elements specified using CMD
# - "$ docker exec -it ..." can be used to run other command on the running container
# - use --entrypoint="" in the docker run to overwrite the default ENTRYPOINT
#ENTRYPOINT ["python3"]
#CMD ["./benchmark.py"]
ENTRYPOINT ["python3", "./benchmark.py"]

# Note: Docker uses kernel, memory and swap of the host, so system-wide host
# swappiness, file limits, etc. should be tuned on the host

#-------------------------------------------------------------------------------

# Expected to be built as
# $ docker build [--no-cache] [--pull] [--squash] [--compress] -t luaxi/clubmark-env:v3.0-U16.04 .
# Note: `luaxi/clubmark-env` is the same as `luaxi/clubmark-env:latest`
# $ docker build -t luaxi/clubmark-env:v3.0-U16.04 -t luaxi/clubmark-env .
# $ docker push luaxi/clubmark-env

# Expected to be called as:
# $ docker run -it -u $UID -v `pwd`:$WORK_DIR luaxi/clubmark-env:v3.0-U16.04 [<clubmark_args>]
# Or to open a shell in the benchmarking directory:
# $ docker run -it --entrypoint "" -u $UID -v `pwd`:/opt/clubmark luaxi/pycabem:env-U16.04-v2.0

# Notes:
# - "$UID" or "`id -u $USER`" is host user id, otherwise default user is "root",
#  which results in read-only files owned by the root created on benchmarking execution.
#  $UID might not be defined in non-bash shells unlike $USER.
# - "-w /opt/clubmark" should be used if the WORKDIR was omitted in the build file

#-------------------------------------------------------------------------------
# Change log:
#
# 3.0.0a  - WebUI added, interfaces extended, lots of fixes made
# 2.0.2  - h5py added for the evaluations output to the HDF5 file
# 2.0.1  - hwloc added for the automatic identification of the CPUs enumeration
#	type (required for the affinity masking)
# 2.0.0  - Initial environment for the benchmarking made as a docker container
