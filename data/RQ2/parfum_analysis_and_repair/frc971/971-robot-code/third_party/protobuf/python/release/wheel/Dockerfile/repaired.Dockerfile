FROM quay.io/pypa/manylinux1_x86_64

RUN yum install -y libtool && rm -rf /var/cache/yum
RUN /opt/python/cp27-cp27mu/bin/pip install twine

COPY protobuf_optimized_pip.sh /
