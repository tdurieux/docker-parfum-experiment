# Copyright (c) Meta Platforms, Inc. and affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
ARG os_release="latest"
FROM ubuntu:${os_release} AS builder
ARG aws_release="1.8.177"
# Required Packages for AWS
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update && apt-get install --no-install-recommends -y \
    build-essential \
    ca-certificates \
    cmake \
    git \
    libcurl4-openssl-dev \
    libssl-dev \
    zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir /root/build
WORKDIR /root/build

# aws s3/core build and install
RUN git clone https://github.com/aws/aws-sdk-cpp.git
WORKDIR /root/build/aws-sdk-cpp
RUN git checkout tags/${aws_release} -b ${aws_release}
# -DCUSTOM_MEMORY_MANAGEMENT=0 is added to avoid Aws::String and std::string issue
# -DENABLE_TESTING=OFF for a weird failing test HttpClientTest.TestRandomURLWithProxyAndOtherDeclaredAsNonProxyHost
RUN cmake . -DBUILD_ONLY="s3;core" -DCMAKE_BUILD_TYPE=RelWithDebInfo -DBUILD_SHARED_LIBS=OFF -DCUSTOM_MEMORY_MANAGEMENT=0 -DENABLE_TESTING=OFF
RUN make && make install

FROM ubuntu:${os_release}
COPY --from=builder /usr/local/include/. /usr/local/include/.
COPY --from=builder /usr/local/lib/. /usr/local/lib/.
ENTRYPOINT [ "sh" ]
