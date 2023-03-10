FROM eddl-superbuild

RUN apt-get -y update && apt-get -y install --no-install-recommends \
      python3-dev \
      python3-pip && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip install --upgrade --no-cache-dir \
      setuptools pip numpy 'pybind11<2.6' pytest

# Run git submodule update [--init] --recursive first
COPY . /pyeddl

WORKDIR /pyeddl

ENV CPATH="/eddl/build/cmake/third_party/eigen/include/eigen3:${CPATH}"
RUN python3 setup.py install
