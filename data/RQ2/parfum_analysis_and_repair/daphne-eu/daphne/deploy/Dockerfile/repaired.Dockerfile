# Copyright 2021 The DAPHNE Consortium
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

FROM ubuntu:latest
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install build-essential libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y llvm-10 llvm-10-dev clang-10 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ninja-build && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nano && rm -rf /var/lib/apt/lists/*;
RUN mv /usr/bin/clang-10 /usr/bin/clang
RUN mv /usr/bin/clang++-10 /usr/bin/clang++
RUN apt-get install -y --no-install-recommends python3.8 && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends -y install tzdata && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends install -y openjdk-11-jdk && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends install -y pkg-config && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y uuid-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y lldb-10 libllvm10 llvm-10-runtime && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y lld && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libncurses5-dev libncursesw5-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir sources && cd sources && wget https://github.com/Kitware/CMake/releases/download/v3.20.2/cmake-3.20.2.tar.gz
RUN cd /sources/ && gunzip cmake-3.20.2.tar.gz && tar -xvf cmake-3.20.2.tar && cd cmake-3.20.2 && rm cmake-3.20.2.tar
RUN cd /sources/cmake-3.20.2/ && ./bootstrap && make && make install
RUN apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y update
RUN apt-get install --no-install-recommends -y gfortran && rm -rf /var/lib/apt/lists/*;
CMD echo "Done"
