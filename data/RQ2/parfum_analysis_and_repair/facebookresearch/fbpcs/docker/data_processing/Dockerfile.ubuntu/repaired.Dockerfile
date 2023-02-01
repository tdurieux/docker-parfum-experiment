# Copyright (c) Meta Platforms, Inc. and affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
ARG os_release="latest"
ARG fbpcf_image="fbpcf/ubuntu:latest"

FROM ${fbpcf_image} as dev

RUN mkdir -p /root/build/data_processing
WORKDIR /root/build/data_processing

# cmake files
COPY docker/data_processing/CMakeLists.txt .
# data processing build and install
COPY fbpcs/performance_tools/ ./fbpcs/performance_tools
COPY fbpcs/data_processing/attribution_id_combiner/ ./fbpcs/data_processing/attribution_id_combiner
COPY fbpcs/data_processing/common/ ./fbpcs/data_processing/common
COPY fbpcs/data_processing/hash_slinging_salter/ ./fbpcs/data_processing/hash_slinging_salter
COPY fbpcs/data_processing/id_combiner/ ./fbpcs/data_processing/id_combiner
COPY fbpcs/data_processing/lift_id_combiner/ ./fbpcs/data_processing/lift_id_combiner
COPY fbpcs/data_processing/pid_preparer/ ./fbpcs/data_processing/pid_preparer
COPY fbpcs/data_processing/sharding/ ./fbpcs/data_processing/sharding

RUN cmake . -DTHREADING=ON -DEMP_USE_RANDOM_DEVICE=ON
RUN make && make install

CMD ["/bin/sh"]

# Create a minified prod build with only required libraries (no source)
FROM ubuntu:${os_release} as prod
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update && apt-get install -y --no-install-recommends \
    ca-certificates \
    libboost-regex1.71.0 \
    libcurl4 \
    libdouble-conversion3 \
    libgflags2.2 \
    libgmp10 \
    libgoogle-glog0v5 \
    libssl1.1 \
    libre2-5 \
    zlib1g && rm -rf /var/lib/apt/lists/*;

COPY --from=dev /root/build/data_processing/bin/. /usr/local/bin/.
RUN useradd -ms /bin/bash pcs
USER pcs
WORKDIR /usr/local/bin
CMD ["/bin/sh"]
