FROM quay.io/pypa/manylinux2014_x86_64:latest
RUN yum install -y cmake swig freeglut-devel zlib-devel && rm -rf /var/cache/yum
ADD . / io/
WORKDIR /io
CMD ./build_wheels.sh
