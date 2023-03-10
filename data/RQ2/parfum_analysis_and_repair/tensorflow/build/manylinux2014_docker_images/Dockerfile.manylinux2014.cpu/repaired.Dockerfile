FROM quay.io/pypa/manylinux2014_x86_64

LABEL maintainer="Subin Modeel <smodeel@redhat.com>"

# Copy and run each install script one at a time for better layer caching.

COPY install/install_rpm_packages.sh /install/
RUN /install/install_rpm_packages.sh

COPY install/install_golang.sh /install/
RUN /install/install_golang.sh

COPY install/install_proto3.sh /install/
RUN /install/install_proto3.sh

COPY install/install_buildifier.sh /install/
RUN /install/install_buildifier.sh

COPY install/install_bazel.sh /install/
RUN /install/install_bazel.sh

# manylinux2014 - devtoolset-7 and python3.6
COPY install/install_pip_packages.sh /install/
RUN source scl_source enable devtoolset-7 rh-python36 && \
    /install/install_pip_packages.sh

# Set up the master bazelrc configuration file.
COPY install/bazelrc /etc/bazel.bazelrc