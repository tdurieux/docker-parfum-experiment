# https://github.com/moby/moby/releases/tag/v17.05.0-ce
ARG BASE_IMAGE=centos
FROM ${BASE_IMAGE}

# Test with non-root user.
ENV TEST_USER tester
ENV WORK_DIR "/work"

RUN uname -a
RUN yum -y update
RUN yum -y install epel-release && rm -rf /var/cache/yum
RUN yum -y install \
  --setopt=deltarpm=0 \
  --setopt=install_weak_deps=false \
  --setopt=tsflags=nodocs \
  file \
  gcc \
  git \
  make \
  redhat-rpm-config \
  sudo \
  automake autoconf libtool perl-Text-Diff pkgconf-pkg-config --setopt=install_weak_deps=false \
  --setopt=tsflags=nodocs \
  file \
  gcc \
  git \
  make \
  redhat-rpm-config \
  sudo \
  automake autoconf libtool perl-Text-Diff pkgconf-pkg-config --setopt=tsflags=nodocs \
  file \
  gcc \
  git \
  make \
  redhat-rpm-config \
  sudo \
  automake autoconf libtool perl-Text-Diff pkgconf-pkg-config && rm -rf /var/cache/yum

# Create test user and the environment
RUN useradd "${TEST_USER}"
WORKDIR "${WORK_DIR}"
COPY . .
RUN chown -R "${TEST_USER}:${TEST_USER}" "${WORK_DIR}"

# Enable sudo without password for convenience.
RUN echo "${TEST_USER} ALL = NOPASSWD: ALL" >> /etc/sudoers

USER "${TEST_USER}"
