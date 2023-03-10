##############################################################################
# keylime TPM 1.2 Dockerfile
#
# This file is for automatic test running of Keylime.
# It is not recommended for use beyond testing scenarios.
##############################################################################

FROM fedora:31
MAINTAINER Luke Hinds <lhinds@redhat.com>
LABEL version="5.5.0" description="Keylime - Bootstrapping and Maintaining Trust"

# environment variables
ARG BRANCH=master

ENV HOME /root
ENV TPM_HOME ${HOME}/tpm4720-keylime

# Packaged dependencies
RUN dnf -y update
RUN dnf -y install git \
           golang \
           python3-devel \
           python3-pip \
           python3-setuptools \
           python3-tornado \
           python3-virtualenv \
           python3-zmq \
           python3-yaml \
           python3-dbus \
           python3-cryptography \
           python3-sqlalchemy \
           procps \
           openssl-devel \
           libtool \
           gcc \
           make \
           automake \
           redhat-rpm-config \
           libselinux-python3

RUN dnf clean all

# Build and install TPM 1.2 simulator
RUN git clone https://github.com/keylime/tpm4720-keylime ${TPM_HOME}
WORKDIR ${TPM_HOME}/tpm
RUN make -f makefile-tpm
RUN install -c tpm_server /usr/local/bin/tpm_server
WORKDIR ${TPM_HOME}/libtpm
RUN ./autogen
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN /usr/bin/make
RUN /usr/bin/make install
WORKDIR ${TPM_HOME}/scripts
RUN /usr/bin/install -c tpm_serverd /usr/local/bin/tpm_serverd
RUN /usr/bin/install -c init_tpm_server /usr/local/bin/init_tpm_server
RUN /usr/local/bin/tpm_serverd
RUN /usr/local/bin/init_tpm_server
