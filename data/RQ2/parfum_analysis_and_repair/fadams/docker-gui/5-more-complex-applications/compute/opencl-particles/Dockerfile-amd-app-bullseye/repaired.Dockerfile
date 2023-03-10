#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

FROM debian:bullseye-slim

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    # Add the packages
    apt-get install -y --no-install-recommends \
    ocl-icd-libopencl1 ocl-icd-opencl-dev libnuma1 clinfo \
    libxmu-dev freeglut3-dev libglew-dev libgl1-mesa-glx \
    libgl1-mesa-dri wget bzip2 ca-certificates tar gcc g++ make && \
    # Add the AMD APP OpenCL Installable Client Driver
    mkdir -p /opt/amd/opencl/install && \
    cd /opt/amd/opencl/install && \
    wget -O AMD-APP-SDKInstaller-v3.0.130.136-GA-linux64.tar.bz2 "https://archive.org/download/AMDAPPSDK/AMD-APP-SDKInstaller-v3.0.130.136-GA-linux64.tar.bz2" && \
    tar xjf AMD-APP-SDKInstaller-v3.0.130.136-GA-linux64.tar.bz2 && \
    ./AMD-APP-SDK-v3.0.130.136-GA-linux64.sh --tar xvfp && \
    mv lib/x86_64/libamdocl12cl64.so /opt/amd/opencl && \
    mv lib/x86_64/sdk/libamdocl64.so /opt/amd/opencl && \
    # Add ICD to the ICD registry
    mkdir -p /etc/OpenCL/vendors && \
    echo "/opt/amd/opencl/libamdocl64.so" > \
         /etc/OpenCL/vendors/amdocl64.icd && \
    # Download the Nvidia SDK which includes the OpenCL samples.
    # Note that the samples listed at https://developer.nvidia.com/opencl
    # are incomplete, missing the "shared" and "common" code needed to
    # compile! We therefore pull the 4.2.9 SDK here, because that is the
    # last version to include the full compilable OpenCL source tree.
    cd /usr/local/src && \
    wget -O gpucomputingsdk_4.2.9_linux.run "https://developer.download.nvidia.com/compute/cuda/4_2/rel/sdk/gpucomputingsdk_4.2.9_linux.run" && \
    chmod +x gpucomputingsdk_4.2.9_linux.run && \
    ./gpucomputingsdk_4.2.9_linux.run --tar xfp && \
    rm gpucomputingsdk_4.2.9_linux.run && \
    rm install-sdk-linux.pl && \
    mv sdk/OpenCL sdk/shared . && \
    rm -rf sdk && rm -rf shared/lib/linux && \
    sed -i 's/GLEW_x86_64/GLEW/' \
        /usr/local/src/OpenCL/common/common_opencl.mk && \
    sed -i 's/-Wimplicit//' \
        /usr/local/src/OpenCL/common/common_opencl.mk && \
    # Replace hard-coded CL_DEVICE_TYPE_GPU with CL_DEVICE_TYPE_CPU
    # so the samples will work (as far as possible) on Intel CPU device.
    for i in $(grep -rwl /usr/local/src/OpenCL/src -e CL_DEVICE_TYPE_GPU); do sed -i 's/CL_DEVICE_TYPE_GPU/CL_DEVICE_TYPE_CPU/' $i; done && \
    cd OpenCL && \
    mv src/oclParticles . && rm -rf src/* && \
    mv oclParticles src/. && \
    make && \
    chmod 777 /usr/local/bin && \
    mkdir -p /usr/local/bin/src && \
    cp /usr/local/src/OpenCL/bin/linux/release/oclParticles \
       /usr/local/bin/. && \
    cp /usr/local/src/OpenCL/src/oclParticles/*.cl \
       /usr/local/bin/src/. && \
    # Remove packages used for installation
    rm -rf /opt/amd/opencl/install && \
    rm -rf /usr/local/src/* && \
    apt-get clean && \
    apt-get purge -y wget bzip2 ca-certificates gcc g++ \
            make && \
    apt-get autoremove -y && \
	rm -rf /var/lib/apt/lists/* && rm AMD-APP-SDKInstaller-v3.0.130.136-GA-linux64.tar.bz2

# Set WORKDIR and use relative path as this example uses Nvidia's
# shrFindFilePath to find the kernel directory and using the absolute
# path doesn't work correctly.
WORKDIR /usr/local/bin/
ENTRYPOINT ["oclParticles"]

#-------------------------------------------------------------------------------
# Example usage
#
# Build the image
# docker build -t opencl-particles-amd-app -f Dockerfile-amd-app-bullseye .

