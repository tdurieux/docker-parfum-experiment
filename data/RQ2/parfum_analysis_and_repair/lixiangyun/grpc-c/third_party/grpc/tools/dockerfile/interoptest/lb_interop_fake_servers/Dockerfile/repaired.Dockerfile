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

FROM golang:1.10

RUN apt-get update && apt-get install --no-install-recommends -y \
  dnsutils \
  git \
  vim \
  curl \
  python-pip \
  python-yaml \
  make && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN ln -s /usr/local/go/bin/go /usr/local/bin

# Install Python packages from PyPI
RUN pip install --no-cache-dir --upgrade pip==10.0.1
RUN pip install --no-cache-dir virtualenv
RUN pip install --no-cache-dir futures==2.2.0 enum34==1.0.4 protobuf==3.5.2.post1 six==1.10.0 twisted==17.5.0

# Define the default command.
CMD ["bash"]
