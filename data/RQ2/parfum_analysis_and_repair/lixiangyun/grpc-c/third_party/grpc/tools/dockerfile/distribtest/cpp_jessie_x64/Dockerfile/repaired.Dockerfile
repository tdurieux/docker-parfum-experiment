# Copyright 2016 gRPC authors.
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

FROM debian:jessie

# Install packages needed for gRPC and protobuf
RUN apt-get update && apt-get install --no-install-recommends -y \
      autoconf \
      automake \
      build-essential \
      curl \
      git \
      g++ \
      libtool \
      make \
      pkg-config \
      unzip && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y golang && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN echo "deb http://ftp.debian.org/debian jessie-backports main" | tee /etc/apt/sources.list.d/jessie-backports.list
RUN apt-get update && apt-get install --no-install-recommends -t jessie-backports -y cmake && apt-get clean && rm -rf /var/lib/apt/lists/*;

CMD ["bash"]
