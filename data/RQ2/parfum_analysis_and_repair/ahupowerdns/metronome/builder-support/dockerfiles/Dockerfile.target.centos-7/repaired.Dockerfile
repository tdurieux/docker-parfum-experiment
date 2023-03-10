# First do the source builds
@INCLUDE Dockerfile.target.sdist

# This defines the dstribution base layer
# Put only the bare minimum of common commands here, without dev tools
FROM centos:7 as dist-base
ARG BUILDER_CACHE_BUSTER=
RUN yum install -y epel-release && rm -rf /var/cache/yum

# Do the actual rpm build
@INCLUDE Dockerfile.rpmbuild
