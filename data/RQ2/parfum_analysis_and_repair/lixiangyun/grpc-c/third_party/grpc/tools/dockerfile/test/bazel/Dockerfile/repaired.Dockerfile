# Copyright 2015 gRPC authors.
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

FROM gcr.io/oss-fuzz-base/base-builder

# Install basic packages and Bazel dependencies.
RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common python-software-properties && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update && apt-get -y --no-install-recommends install \
  autoconf \
  build-essential \
  curl \
  libtool \
  make \
  openjdk-8-jdk \
  vim && rm -rf /var/lib/apt/lists/*;

#====================
# Python dependencies

# Install dependencies

RUN apt-get update && apt-get install --no-install-recommends -y \
    python-all-dev \
    python3-all-dev \
    python-pip && rm -rf /var/lib/apt/lists/*;

# Install Python packages from PyPI
RUN pip install --no-cache-dir --upgrade pip==10.0.1
RUN pip install --no-cache-dir virtualenv
RUN pip install --no-cache-dir futures==2.2.0 enum34==1.0.4 protobuf==3.5.2.post1 six==1.10.0 twisted==17.5.0


#========================
# Bazel installation

RUN apt-get update && apt-get install --no-install-recommends -y wget && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN wget -q https://github.com/bazelbuild/bazel/releases/download/0.17.1/bazel-0.17.1-linux-x86_64 -O /usr/local/bin/bazel
RUN chmod 755 /usr/local/bin/bazel


RUN mkdir -p /var/local/jenkins

# Define the default command.
CMD ["bash"]
