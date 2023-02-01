# Copyright (c) Meta Platforms, Inc. and affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
ARG os_release="latest"
ARG fbpcf_image="fbpcf/ubuntu:latest"

FROM ${fbpcf_image} as dev

RUN mkdir -p /root/build/emp_game
WORKDIR /root/build/emp_game

# cmake files
COPY docker/emp_games/CMakeLists.txt .
COPY docker/emp_games/common.cmake .
COPY docker/emp_games/perf_tools.cmake .
# attribution, lift and shard aggregator build and install
COPY fbpcs/performance_tools/ ./fbpcs/performance_tools
COPY fbpcs/emp_games/attribution/ ./fbpcs/emp_games/attribution
COPY fbpcs/emp_games/pcf2_attribution/ ./fbpcs/emp_games/pcf2_attribution
COPY fbpcs/emp_games/pcf2_aggregation/ ./fbpcs/emp_games/pcf2_aggregation
COPY fbpcs/emp_games/lift/ ./fbpcs/emp_games/lift
COPY fbpcs/emp_games/common/ ./fbpcs/emp_games/common

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

COPY --from=dev /root/build/emp_game/bin/. /usr/local/bin/.
RUN useradd -ms /bin/bash pcs
USER pcs
WORKDIR /usr/local/bin
CMD ["/bin/sh"]
