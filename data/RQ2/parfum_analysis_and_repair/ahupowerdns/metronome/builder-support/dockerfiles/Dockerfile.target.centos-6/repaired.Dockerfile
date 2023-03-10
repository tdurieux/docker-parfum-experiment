# First do the source builds
@INCLUDE Dockerfile.target.sdist

# This defines the dstribution base layer
# Put only the bare minimum of common commands here, without dev tools
FROM centos:6 as dist-base
ARG BUILDER_CACHE_BUSTER=
RUN yum install -y --verbose epel-release centos-release-scl-rh && \
    yum install -y --nogpgcheck devtoolset-7-gcc-c++ && rm -rf /var/cache/yum

# Do the actual rpm build
@INCLUDE Dockerfile.rpmbuild
