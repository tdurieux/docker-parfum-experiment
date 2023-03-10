FROM centos:7

# Docker build arguments
ARG SOURCE_DIR=/jellyfin
ARG ARTIFACT_DIR=/dist

# Docker run environment
ENV SOURCE_DIR=/jellyfin
ENV ARTIFACT_DIR=/dist
ENV IS_DOCKER=YES

# Prepare CentOS environment
RUN yum update -y \
  && yum install -y epel-release \
  && yum install -y @buildsys-build rpmdevtools git yum-plugins-core autoconf automake glibc-devel gcc-c++ make \
  && curl -fsSL https://rpm.nodesource.com/setup_12.x | bash - \
  && yum install -y nodejs && rm -rf /var/cache/yum

# Link to build script
RUN ln -sf ${SOURCE_DIR}/deployment/build.centos /build.sh

VOLUME ${SOURCE_DIR}

VOLUME ${ARTIFACT_DIR}

ENTRYPOINT ["/build.sh"]
