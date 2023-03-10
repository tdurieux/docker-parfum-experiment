# Copyright (c) 2019, NVIDIA CORPORATION. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#  * Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#  * Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#  * Neither the name of NVIDIA CORPORATION nor the names of its
#    contributors may be used to endorse or promote products derived
#    from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ``AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
# OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Default setting is building on ubuntu:18.04
FROM nvcr.io/nvidia/tensorrtserver:20.02-py3-clientsdk

ENV PATH //workspace/install/bin:${PATH}
ENV LD_LIBRARY_PATH /workspace/install/lib:${LD_LIBRARY_PATH}

ARG TRTIS_CLIENT_SRC="/workspace/"
ARG TRTIS_CLIENT_LIB="/workspace/install/lib"

ARG BUILD_DIR="/workspace/tacotron2waveglow"

ENV C_INCLUDE_PATH=${TRTIS_CLIENT_SRC}/install/include
ENV CPLUS_INCLUDE_PATH=${TRTIS_CLIENT_SRC}/install/include

# build the client code
RUN mkdir -p "${BUILD_DIR}"
ADD src/ "${BUILD_DIR}/src"
ADD CMakeLists.txt "${BUILD_DIR}/"
ADD configure "${BUILD_DIR}/"

WORKDIR "${BUILD_DIR}"
RUN ln -s "${TRTIS_CLIENT_SRC}" "trtis_include"
RUN ln -s "${TRTIS_CLIENT_LIB}" "trtis_lib"
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make

WORKDIR "/workspace"

RUN mkdir "${BUILD_DIR}/bin"
RUN cp -v "${BUILD_DIR}/build/bin/trtis_client" "${BUILD_DIR}/bin"

ENV PATH "${BUILD_DIR}/bin:${PATH}"

RUN mkdir -p data/
