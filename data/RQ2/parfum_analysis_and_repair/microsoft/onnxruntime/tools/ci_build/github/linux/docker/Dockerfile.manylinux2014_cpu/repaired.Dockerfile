FROM quay.io/pypa/manylinux2014_x86_64:latest

ENV PATH /usr/local/gradle/bin:/opt/rh/devtoolset-10/root/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ADD scripts /tmp/scripts
RUN cd /tmp/scripts && /tmp/scripts/manylinux/install_centos.sh && /tmp/scripts/manylinux/install_deps.sh && rm -rf /tmp/scripts

ARG BUILD_UID=1001
ARG BUILD_USER=onnxruntimedev
RUN adduser --uid $BUILD_UID $BUILD_USER
WORKDIR /home/$BUILD_USER
USER $BUILD_USER