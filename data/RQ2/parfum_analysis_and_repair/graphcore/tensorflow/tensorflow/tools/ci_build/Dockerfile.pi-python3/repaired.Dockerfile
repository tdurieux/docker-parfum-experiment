FROM ubuntu:16.04

LABEL maintainer="Terry Heo <terryheo@google.com>"

ENV CI_BUILD_PYTHON=python3
ENV CROSSTOOL_PYTHON_INCLUDE_PATH=/usr/include/python3.5

# Copy and run the install scripts.
COPY install/*.sh /install/
RUN /install/install_bootstrap_deb_packages.sh
RUN add-apt-repository -y ppa:openjdk-r/ppa
RUN /install/install_deb_packages.sh --without_cmake
RUN /install/install_cmake.sh
RUN /install/install_pip_packages.sh
RUN /install/install_bazel.sh
RUN /install/install_proto3.sh
RUN /install/install_buildifier.sh
RUN /install/install_auditwheel.sh
RUN /install/install_golang.sh

# The following line installs the Python cross-compilation toolchain. All the
# preceding dependencies should be kept in sync with the main CPU docker file.
RUN /install/install_pi_python3_toolchain.sh

# Set up the master bazelrc configuration file.
COPY install/.bazelrc /etc/bazel.bazelrc

# XLA is not needed for PI
ENV TF_ENABLE_XLA=0