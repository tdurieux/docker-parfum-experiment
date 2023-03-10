# Copyright 2019 The TensorFlow Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Dockerfile for building a manylinux2014 struct2tensor wheel.
ARG PYTHON_VERSION
FROM tensorflow/build:latest-python${PYTHON_VERSION}
WORKDIR /struct2tensor

# Uses manylinux2014 compatible devtoolset. See below for the detail:
# https://github.com/tensorflow/build/blob/master/tf_sig_build_dockerfiles/builder.devtoolset/build_devtoolset.sh
ENV CC=/dt9/usr/bin/gcc

# tensorflow/build images already contains nightly packages. Clean them up.
RUN pip uninstall -y tf-nightly tb-nightly tf-estimator-nightly keras-nightly

RUN pip install --no-cache-dir auditwheel

# Update binutils to avoid linker(gold) issue. See b/227299577#comment9
RUN wget https://old-releases.ubuntu.com/ubuntu/pool/main/b/binutils/binutils_2.35.1-1ubuntu1_amd64.deb \
 && wget https://old-releases.ubuntu.com/ubuntu/pool/main/b/binutils/binutils-x86-64-linux-gnu_2.35.1-1ubuntu1_amd64.deb \
 && wget https://old-releases.ubuntu.com/ubuntu/pool/main/b/binutils/binutils-common_2.35.1-1ubuntu1_amd64.deb \
 && wget https://old-releases.ubuntu.com/ubuntu/pool/main/b/binutils/libbinutils_2.35.1-1ubuntu1_amd64.deb
RUN dpkg -i binutils_2.35.1-1ubuntu1_amd64.deb \
            binutils-x86-64-linux-gnu_2.35.1-1ubuntu1_amd64.deb \
            binutils-common_2.35.1-1ubuntu1_amd64.deb \
            libbinutils_2.35.1-1ubuntu1_amd64.deb

CMD ["struct2tensor/tools/docker_build/build_manylinux.sh"]
