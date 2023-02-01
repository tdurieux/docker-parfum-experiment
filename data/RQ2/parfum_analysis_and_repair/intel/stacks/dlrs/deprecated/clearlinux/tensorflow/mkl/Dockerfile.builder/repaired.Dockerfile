#---------------------------------------------------------------------
# Base instance to build MKL based images on Clear Linux
#---------------------------------------------------------------------
ARG clear_ver
FROM clearlinux/stacks-clearlinux:$clear_ver as base
LABEL maintainer=otc-swstacks@intel.com

# update os and add required bundles
RUN swupd bundle-add git curl wget \
    java-basic sysadmin-basic package-utils \
    devpkg-zlib go-basic devpkg-tbb

# fix for stdlib not found issue