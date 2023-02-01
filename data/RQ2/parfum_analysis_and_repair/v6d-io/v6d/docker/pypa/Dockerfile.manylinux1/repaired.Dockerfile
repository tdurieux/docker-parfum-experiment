# Copyright 2020-2021 Alibaba Group Holding Limited.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM quay.io/pypa/manylinux2010_x86_64:2022-05-08-ac9d5ec

# target: docker.pkg.github.com/v6d-io/v6d/vineyard-manylinux1:20220512

RUN export PATH=$PATH:/opt/python/cp37-cp37m/bin && \
    mkdir /deps && \
    cd /deps && \
    echo "Installing cmake ..." && \
    curl -f -L https://cmake.org/files/v3.16/cmake-3.16.3-Linux-x86_64.sh --output cmake-3.16.3-Linux-x86_64.sh && \
    bash ./cmake-3.16.3-Linux-x86_64.sh --skip-license --prefix=/usr && \
    echo "Installing glog ..." && \
    cd /deps && \
    curl -f -L https://github.com/google/glog/archive/v0.5.0.tar.gz --output glog-v0.5.0.tar.gz && \
    tar zxvf glog-v0.5.0.tar.gz && \
    cd glog-0.5.0 && \
    mkdir build-dir && \
    cd build-dir && \
    cmake .. -DBUILD_SHARED_LIBS=OFF \
             -DBUILD_TESTING=OFF \
             -DWITH_GFLAGS=OFF \
             -DCMAKE_POSITION_INDEPENDENT_CODE=ON && \
    make install -j`nproc` && \
    echo "Installing gflags ..." && \
    cd /deps && \
    curl -f -L https://github.com/gflags/gflags/archive/v2.2.2.tar.gz --output gflags-v2.2.2.tar.gz && \
    tar zxf gflags-v2.2.2.tar.gz && \
    cd gflags-2.2.2 && \
    mkdir -p build-dir && \
    cd build-dir && \
    cmake .. -DBUILD_SHARED_LIBS=OFF && \
    make install -j`nproc` && \
    echo "Installing boost header libraries ..." && \
    cd /deps && \
    curl -f -L https://boostorg.jfrog.io/artifactory/main/release/1.77.0/source/boost_1_77_0.tar.gz \
        --output boost_1_77_0.tar.gz && \
    tar zxvf boost_1_77_0.tar.gz --exclude="*.html" --exclude="*/docs/*" && \
    cp -R boost_1_77_0/boost /usr/local/include/ && \
    echo "Installing apache-arrow ..." && \
    cd /deps && \
    curl -f -L https://github.com/apache/arrow/archive/apache-arrow-1.0.1.tar.gz --output apache-arrow-1.0.1.tar.gz && \
    tar zxvf apache-arrow-1.0.1.tar.gz && \
    cd arrow-apache-arrow-1.0.1 && \
    mkdir build-dir && \
    cd build-dir && \
    cmake ../cpp \
        -DARROW_COMPUTE=ON \
        -DARROW_WITH_UTF8PROC=OFF \
        -DARROW_CSV=ON \
        -DARROW_CUDA=OFF \
        -DARROW_DATASET=OFF \
        -DARROW_FILESYSTEM=ON \
        -DARROW_FLIGHT=OFF \
        -DARROW_GANDIVA=OFF \
        -DARROW_GANDIVA_JAVA=OFF \
        -DARROW_HDFS=OFF \
        -DARROW_HIVESERVER2=OFF \
        -DARROW_JSON=OFF \
        -DARROW_ORC=OFF \
        -DARROW_PARQUET=OFF \
        -DARROW_PLASMA=OFF \
        -DARROW_PLASMA_JAVA_CLIENT=OFF \
        -DARROW_PYTHON=OFF \
        -DARROW_S3=OFF \
        -DARROW_WITH_BZ2=OFF \
        -DARROW_WITH_ZLIB=OFF \
        -DARROW_WITH_LZ4=OFF \
        -DARROW_WITH_SNAPPY=OFF \
        -DARROW_WITH_ZSTD=OFF \
        -DARROW_WITH_BROTLI=OFF \
        -DARROW_IPC=ON \
        -DARROW_BUILD_BENCHMARKS=OFF \
        -DARROW_BUILD_EXAMPLES=OFF \
        -DARROW_BUILD_INTEGRATION=OFF \
        -DARROW_BUILD_UTILITIES=OFF \
        -DARROW_BUILD_TESTS=OFF \
        -DARROW_ENABLE_TIMING_TESTS=OFF \
        -DARROW_FUZZING=OFF \
        -DARROW_USE_ASAN=OFF \
        -DARROW_USE_TSAN=OFF \
        -DARROW_USE_UBSAN=OFF \
        -DARROW_JEMALLOC=OFF \
        -DARROW_BUILD_SHARED=OFF \
        -DARROW_BUILD_STATIC=ON \
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON && \
    make install -j`nproc` && \
    echo "Prepare python dev dependencies ..." && \
    pip3 install --no-cache-dir libclang parsec && \
    echo "Done." && \
    rm -rf /deps && rm glog-v0.5.0.tar.gz
