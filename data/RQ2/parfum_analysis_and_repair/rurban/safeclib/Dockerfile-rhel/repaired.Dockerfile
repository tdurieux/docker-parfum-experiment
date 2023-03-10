# Docker >= 17.05.0-ce allows using build-time args (ARG) in FROM (#31352).
# https://github.com/moby/moby/releases/tag/v17.05.0-ce
ARG BASE_IMAGE=fedora
FROM ${BASE_IMAGE}

# Test with non-root user.
ENV TEST_USER tester
ENV WORK_DIR "/work"

RUN uname -a
RUN echo -e "deltarpm=0\ninstall_weak_deps=0\ntsflags=nodocs" >> /etc/dnf/dnf.conf
# Disable modular repositories to save a running time of "dnf update"
# if they exists.
RUN ls /etc/yum.repos.d/*.repo
RUN sed -i '/^enabled=1$/ s/1/0/' /etc/yum.repos.d/*-modular.repo || true
RUN dnf -y update
RUN dnf -y --allowerasing install \
  file \
  gcc \
  git \
  make \
  redhat-rpm-config \
  sudo \
  automake autoconf libtool perl-Text-Diff pkgconf-pkg-config

# Create test user and the environment
RUN useradd "${TEST_USER}"
WORKDIR "${WORK_DIR}"
COPY . .
RUN chown -R "${TEST_USER}:${TEST_USER}" "${WORK_DIR}"

# Enable sudo without password for convenience.