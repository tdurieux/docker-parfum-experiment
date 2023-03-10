FROM centos:8

VOLUME /output

ENV OUTPUT_DIR /build/dist
ENV BUILD_DIR /build

RUN yum install dnf-plugins-core -y && rm -rf /var/cache/yum
RUN yum config-manager --set-enabled PowerTools -y
RUN yum install -y \
  rpm-build gettext-devel libxml2-devel xz libtool git gcc-c++ doxygen make help2man python36-devel \
  && yum clean all && rm -rf /var/cache/yum

WORKDIR $BUILD_DIR
COPY . .

CMD ["./pkg/dockerfiles/centos8-entrypoint.sh"]
