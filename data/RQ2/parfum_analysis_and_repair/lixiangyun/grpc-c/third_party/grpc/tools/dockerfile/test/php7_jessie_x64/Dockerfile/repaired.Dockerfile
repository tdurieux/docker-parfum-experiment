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

#=================
# PHP7 dependencies

# Install Git and basic packages.
RUN apt-get update && apt-get install --no-install-recommends -y \
  autoconf \
  automake \
  build-essential \
  ccache \
  curl \
  git \
  libcurl4-openssl-dev \
  libgmp-dev \
  libgmp3-dev \
  libssl-dev \
  libtool \
  libxml2-dev \
  pkg-config \
  re2c \
  time \
  unzip \
  wget \
  zip && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Install other dependencies
RUN ln -sf /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h
RUN wget https://ftp.gnu.org/gnu/bison/bison-2.6.4.tar.gz -O /var/local/bison-2.6.4.tar.gz
RUN cd /var/local \
  && tar -zxvf bison-2.6.4.tar.gz \
  && cd /var/local/bison-2.6.4 \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  && make \
  && make install && rm bison-2.6.4.tar.gz

# Compile PHP7 from source
RUN git clone https://github.com/php/php-src /var/local/git/php-src
RUN cd /var/local/git/php-src \
  && git checkout PHP-7.0.9 \
  && ./buildconf --force \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  --with-gmp \
  --with-openssl \
  --with-zlib \
  && make \
  && make install

# Google Cloud platform API libraries
RUN apt-get update && apt-get install --no-install-recommends -y python-pip && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade google-api-python-client oauth2client

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


RUN mkdir /var/local/jenkins

# Define the default command.
CMD ["bash"]
