###############################################################################
# Copyright (c) 2015-2021, Lawrence Livermore National Security, LLC.
# 
# Produced at the Lawrence Livermore National Laboratory
# 
# LLNL-CODE-716457
# 
# All rights reserved.
# 
# This file is part of Ascent. 
# 
# For details, see: http://software.llnl.gov/ascent/.
# 
# Please also read ascent/LICENSE
# 
# Redistribution and use in source and binary forms, with or without 
# modification, are permitted provided that the following conditions are met:
# 
# * Redistributions of source code must retain the above copyright notice, 
#   this list of conditions and the disclaimer below.
# 
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the disclaimer (as noted below) in the
#   documentation and/or other materials provided with the distribution.
# 
# * Neither the name of the LLNS/LLNL nor the names of its contributors may
#   be used to endorse or promote products derived from this software without
#   specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL LAWRENCE LIVERMORE NATIONAL SECURITY,
# LLC, THE U.S. DEPARTMENT OF ENERGY OR CONTRIBUTORS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
# DAMAGES  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, 
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
# IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
# POSSIBILITY OF SUCH DAMAGE.
# 
###############################################################################

FROM ubuntu:latest

# fetch build env
RUN apt-get update && apt-get install -y \
    git \
    git-lfs \
    curl \
    build-essential \
    gcc \
    g++ \
    gfortran \
    zlib1g-dev \
    python \
    vim \
 && rm -rf /var/lib/apt/lists/*


# obtain a copy of vtkh source from host env
COPY vtkh.docker.src.tar.gz /
RUN tar -xzf vtkh.docker.src.tar.gz

# at some sites ssl certs are intercepted, which cases issues fetching 
# tpl sources via https

# to resolve this, either:
# 1) pass the "-k" option to uberenv (recommended), 
# 2) install the proper certs into the image, or
# 3) use  the following commands to disable ssl for git and 
#    curl (both are used by spack):
#RUN git config --global http.sslVerify false
#RUN echo insecure >> ~/.curlrc

# bootstrap third party libs using spack and uberenv
#  for this example we use mpich for MPI
RUN cd vtkh && python scripts/uberenv/uberenv.py -k --spec "%gcc+mpi ^mpich"

# configure a debug build with cmake
RUN cd vtkh && mkdir build-debug
RUN cd vtkh/build-debug && \
    ../uberenv_libs/spack/opt/spack/*/*/cmake*/bin/cmake \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_INSTALL_PREFIX=/vtkh/install-debug \
    -C ../uberenv_libs/*.cmake \
    ../src

# build, test, and install vtk-h
RUN cd vtkh/build-debug && make -j 2
RUN cd vtkh/build-debug && env CTEST_OUTPUT_ON_FAILURE=1 make test
RUN cd vtkh/build-debug && make install


CMD ["/bin/bash"]
