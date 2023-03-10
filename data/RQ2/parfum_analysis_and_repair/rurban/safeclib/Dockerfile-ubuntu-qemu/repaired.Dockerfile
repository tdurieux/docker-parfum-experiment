ARG ARCH=aarch64
ARG BASE_IMAGE=arm64v8/ubuntu
FROM multiarch/qemu-user-static:${ARCH} as qemu

# Docker >= 17.05.0-ce allows using build-time args (ARG) in FROM (#31352).
# https://github.com/moby/moby/releases/tag/v17.05.0-ce
FROM ${BASE_IMAGE}

ARG ARCH=aarch64

# Test with non-root user.
ENV TEST_USER tester
ENV WORK_DIR "/work"

# Put the qemu interpreter to run arch container with a binfmt_misc file
# that does not have the persistent option (flags: F).
COPY --from=qemu /usr/bin/qemu-${ARCH}-static /usr/bin

RUN uname -a
RUN apt-get update -qq && \
  apt-get install -yq --no-install-suggests --no-install-recommends \
  build-essential \
  file \
  gcc \
  make \
  git \
  sudo \
  autotools-dev automake autoconf libtool libtext-diff-perl pkg-config && rm -rf /var/lib/apt/lists/*;

# Create test user and the environment
RUN useradd "${TEST_USER}"
WORKDIR "${WORK_DIR}"
COPY . .
RUN chown -R "${TEST_USER}:${TEST_USER}" "${WORK_DIR}"

# Enable sudo without password for convenience.
RUN echo "${TEST_USER} ALL = NOPASSWD: ALL" >> /etc/sudoers

USER "${TEST_USER}"
