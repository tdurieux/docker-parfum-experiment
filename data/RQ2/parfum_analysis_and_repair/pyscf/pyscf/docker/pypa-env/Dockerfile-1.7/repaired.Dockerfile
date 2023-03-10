FROM quay.io/pypa/manylinux1_x86_64:latest

RUN for PYVERSION in cp27-cp27m cp27-cp27mu cp35-cp35m cp36-cp36m cp37-cp37m cp38-cp38 cp39-cp39; do \
    /opt/python/$PYVERSION/bin/pip install numpy; \
    /opt/python/$PYVERSION/bin/pip download -d /root/wheelhouse numpy scipy h5py; \
  done

RUN yum install -y cmake blas-devel.x86_64 gcc && rm -rf /var/cache/yum
RUN /opt/python/cp37-cp37m/bin/pip install cmake
ENV PATH=/opt/python/cp37-cp37m/bin:$PATH
