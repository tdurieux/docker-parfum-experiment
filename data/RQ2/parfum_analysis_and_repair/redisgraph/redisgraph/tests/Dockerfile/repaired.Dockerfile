FROM redis:latest as builder

ENV DEPS "automake peg libtool autoconf python python-setuptools python-pip python-dev wget build-essential cmake m4 git valgrind"

# Set up a build environment
RUN set -ex ; \
    deps="$DEPS "; \
    apt-get update -qq ; \
    apt-get install -y --no-install-recommends $deps ; rm -rf /var/lib/apt/lists/*; \
    pip install --no-cache-dir wheel; \
    pip install --no-cache-dir Click rmtest backports.csv psutil behave; \
    pip install --no-cache-dir redis-py-cluster; \
    pip install --no-cache-dir git+https://github.com/RedisGraph/redisgraph-py.git@master; \
    pip install --no-cache-dir git+https://github.com/RedisLabsModules/RLTest.git@master

# Build the source
ADD ./ /redisgraph

# Build RedisGraph
WORKDIR /redisgraph
RUN set -ex ;\
    make clean ALL=1 ;\
    make -j `nproc`
