# builder image to build the audiowaveform RPM
FROM centos:8

# Use docker build --build-arg AUDIOWAVEFORM_VERSION=<git-revision> AUDIOWAVEFORM_PACKAGE_VERSION=<version>
ARG AUDIOWAVEFORM_VERSION
ENV AUDIOWAVEFORM_VERSION=${AUDIOWAVEFORM_VERSION}

ARG AUDIOWAVEFORM_PACKAGE_VERSION
ENV AUDIOWAVEFORM_PACKAGE_VERSION=${AUDIOWAVEFORM_PACKAGE_VERSION}

# Use the epel repository (to provide the libmad package)
RUN INSTALL_PKGS="epel-release" && \
    yum install -y --setopt=tsflags=nodocs  $INSTALL_PKGS && rpm -V $INSTALL_PKGS && \
    yum clean all -y && rm -rf /var/cache/yum

RUN yum install -y dnf-plugins-core && \
    yum config-manager --set-enabled powertools && rm -rf /var/cache/yum

# Install audiowaveform build dependencies
RUN INSTALL_PKGS="redhat-lsb-core rpm-build wget git make cmake gcc-c++ libmad-devel libid3tag-devel libsndfile-devel gd-devel boost-devel libmad-devel" && \
    yum install -y --setopt=tsflags=nodocs  $INSTALL_PKGS && rpm -V $INSTALL_PKGS && \
    yum clean all -y && rm -rf /var/cache/yum

RUN yum update -y

# Retrieve and build source (see https://github.com/bbc/audiowaveform#building-from-source)
WORKDIR /usr/local/src

RUN wget -qO- https://github.com/bbc/audiowaveform/archive/${AUDIOWAVEFORM_VERSION}.tar.gz | tar xfz - && \
    cd audiowaveform-${AUDIOWAVEFORM_VERSION} && \
    mkdir build && \
    cd build && \
    cmake -D ENABLE_TESTS=0 .. && \
    make package

WORKDIR /usr/local/src/audiowaveform-${AUDIOWAVEFORM_VERSION}/build

RUN mv audiowaveform-${AUDIOWAVEFORM_PACKAGE_VERSION}-1.x86_64.rpm audiowaveform-${AUDIOWAVEFORM_PACKAGE_VERSION}-1.el8.x86_64.rpm
