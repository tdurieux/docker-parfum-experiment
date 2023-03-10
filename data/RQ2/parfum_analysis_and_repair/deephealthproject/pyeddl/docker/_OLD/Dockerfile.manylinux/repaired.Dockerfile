FROM eddl-manylinux

ENV CPATH="/eddl/build/cmake/third_party/eigen/include/eigen3:${CPATH}"

COPY . /pyeddl
WORKDIR /

RUN for py in cp36-cp36m cp37-cp37m cp38-cp38; do \
      /opt/python/${py}/bin/pip install numpy 'pybind11<2.6' pytest && \
      /opt/python/${py}/bin/pip wheel /pyeddl/ -w wheels && \
      auditwheel repair wheels/pyeddl-*-${py}-linux_x86_64.whl --plat manylinux2010_x86_64 -w /pyeddl/wheels/ && \
      /opt/python/${py}/bin/pip install pyeddl --no-index -f /pyeddl/wheels && \
      /opt/python/${py}/bin/pytest /pyeddl/tests; \
    done