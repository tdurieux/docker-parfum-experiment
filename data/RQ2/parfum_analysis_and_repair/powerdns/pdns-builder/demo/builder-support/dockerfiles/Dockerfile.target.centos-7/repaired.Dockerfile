# First do the source builds
@INCLUDE Dockerfile.target.sdist

# This defines the dstribution base layer
# Put only the bare minimum of common commands here, without dev tools
FROM centos:7 as dist-base
ARG BUILDER_CACHE_BUSTER=
RUN yum install -y epel-release && rm -rf /var/cache/yum
# Python 3.4+ is needed for the builder helpers
RUN yum install -y /usr/bin/python3 && rm -rf /var/cache/yum

# Do the actual rpm build
@INCLUDE Dockerfile.rpmbuild

# Generate provenance
RUN /build/builder/helpers/generate-yum-provenance.py /dist/rpm-provenance.json

# Do a test install and verify
# Can be skipped with skiptests=1 in the environment
@EXEC [ "$skiptests" = "" ] && include Dockerfile.rpmtest

