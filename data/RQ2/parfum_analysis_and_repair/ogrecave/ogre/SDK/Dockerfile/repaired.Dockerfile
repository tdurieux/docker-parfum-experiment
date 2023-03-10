FROM quay.io/pypa/manylinux2014_x86_64:latest
RUN yum install -y zlib-devel libXrandr-devel mesa-libEGL-devel && rm -rf /var/cache/yum
WORKDIR /workspace
CMD PATH="/opt/python/$PYVER/bin/:$PATH" pip wheel . --verbose