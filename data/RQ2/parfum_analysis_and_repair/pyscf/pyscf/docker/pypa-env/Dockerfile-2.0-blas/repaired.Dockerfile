FROM quay.io/pypa/manylinux1_x86_64:latest

RUN yum install -y blas-devel.x86_64 gcc && \
    yum clean all && \
    rm -rf /var/cache/yum
RUN /opt/python/cp37-cp37m/bin/pip install --no-cache-dir cmake
ENV PATH=/opt/python/cp37-cp37m/bin:$PATH

COPY build-wheels.sh /build-wheels.sh
CMD ['/build-wheels.sh']