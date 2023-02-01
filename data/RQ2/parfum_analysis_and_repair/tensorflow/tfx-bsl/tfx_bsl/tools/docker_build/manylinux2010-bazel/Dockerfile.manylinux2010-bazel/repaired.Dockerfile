# Copyright 2020 Google LLC
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

# A docker image that contains the PyPA manylinux2010 toolchain and
# bazel 4.0.0.
# docker build -f Dockerfile.manylinux2010-bazel \
#   --tag gcr.io/tfx-oss-public/manylinux2010-bazel
# docker push gcr.io/tfx-oss-public/manylinux2010-bazel

FROM quay.io/pypa/manylinux2010_x86_64 as bazel_build

RUN yum install -y java-1.8.0-openjdk-devel zip wget && rm -rf /var/cache/yum
WORKDIR /tmp/bazel_build
ADD https://github.com/bazelbuild/bazel/releases/download/4.0.0/bazel-4.0.0-dist.zip bazel.zip
ADD ./build_bazel.sh build_bazel.sh
RUN /bin/bash build_bazel.sh

FROM quay.io/pypa/manylinux2010_x86_64
COPY --from=bazel_build /tmp/bazel_build/output/bazel /bin
RUN yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel zip rh-python36 rsync && rm -rf /var/cache/yum
