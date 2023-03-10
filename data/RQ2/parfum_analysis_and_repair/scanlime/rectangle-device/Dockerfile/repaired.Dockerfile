ARG UBUNTU_RELEASE=20.04
ARG RUSTUP_TOOLCHAIN=1.46.0
ARG GOLANG_RELEASE=1.15.2
ARG PODMAN_TAG=v2.1.0-rc2

ARG DEFAULT_PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

FROM ubuntu:${UBUNTU_RELEASE} AS builder
ARG DEFAULT_PATH
ENV PATH ${DEFAULT_PATH}
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

# Install distro packages

WORKDIR /root
RUN apt-get update && apt-get install --no-install-recommends -y dos2unix && rm -rf /var/lib/apt/lists/*;

COPY docker/install/nodejs-current.sh ./
RUN dos2unix -q nodejs-current.sh; bash ./nodejs-current.sh

COPY docker/install/gvisor.sh ./
RUN dos2unix -q gvisor.sh; sh ./gvisor.sh

COPY docker/install/yarn.sh ./
RUN dos2unix -q yarn.sh; sh ./yarn.sh

COPY docker/install/build-deps.sh ./
RUN dos2unix -q build-deps.sh; sh ./build-deps.sh

# Make non-root users, switch to builder

RUN adduser builder --disabled-login </dev/null >/dev/null 2>/dev/null
RUN adduser rectangle-device --disabled-login </dev/null >/dev/null 2>/dev/null
USER builder:builder
WORKDIR /home/builder

# Install official go binary package

FROM builder as golang
ARG DEFAULT_PATH
ARG GOLANG_RELEASE
ENV GOROOT /home/builder/dist/go
ENV GOPATH /home/builder/go
ENV PATH /home/builder/dist/go/bin:/home/builder/go/bin:${DEFAULT_PATH}
RUN \
 mkdir dist && \
cd dist && \
 curl -f https://dl.google.com/go/go${GOLANG_RELEASE}.linux-amd64.tar.gz | \
tar zxf -

# Build podman from git, with patches

FROM golang as podman
ARG PODMAN_TAG

RUN git clone https://github.com/containers/podman/ -b ${PODMAN_TAG} /home/builder/go/src/github.com/containers/podman
COPY docker/nested-podman/podman-always-rootless.patch /home/builder/go/src/github.com/containers/podman
COPY docker/nested-podman/podman-no-namespace-clone.patch /home/builder/go/src/github.com/containers/podman
RUN \
cd /home/builder/go/src/github.com/containers/podman && \
patch -p1 < podman-always-rootless.patch && \
patch -p1 < podman-no-namespace-clone.patch && \
export GOPATH=/home/builder/go && \
make BUILDTAGS="selinux seccomp -systemd"
USER root
RUN \
cd /home/builder/go/src/github.com/containers/podman && \
make install PREFIX=/usr
USER builder:builder

# Install official rust binary package

FROM builder as rust
ARG DEFAULT_PATH
ARG RUSTUP_TOOLCHAIN
COPY --chown=builder docker/install/rustup-init.sh ./
ENV RUSTUP_TOOLCHAIN ${RUSTUP_TOOLCHAIN}
RUN dos2unix -q rustup-init.sh; ./rustup-init.sh -y 2>&1
ENV PATH /home/builder/.cargo/bin:${DEFAULT_PATH}

# Compile rust dependencies using a skeleton crate, for faster docker rebuilds.
# The list of packages built in this stage is generated by parsing the Cargo.lock
# and filtering out any duplicate versions or problematic packages. This step
# can be removed entirely if it breaks, it's just here to try and make the next
# couple of stages must faster.

FROM rust as skeleton
COPY --chown=builder docker/skeleton/ ./
RUN cargo build --release 2>&1
COPY --chown=builder Cargo.lock ./
RUN target/release/rectangle-device | \
egrep -v '^(rectangle-device|cargo|wasi|redox|wepoll|hermit|ws|win|aesni)' \
>> Cargo.toml && cat Cargo.toml
RUN cargo build --release 2>&1

# Compile player workspace separately, also for faster docker rebuilds

COPY --chown=builder player player
COPY --chown=builder docker/skeleton/Cargo.toml ./
RUN \
echo '[workspace]' >> Cargo.toml && \
echo 'members = [ "player" ]' >> Cargo.toml && \
cd player && cargo build --release -vv 2>&1

# Replace the skeleton with the real app and build it

FROM skeleton as app
COPY --chown=builder Cargo.toml Cargo.toml
COPY --chown=builder sandbox sandbox
COPY --chown=builder blocks blocks
COPY --chown=builder network network
COPY --chown=builder media media
COPY --chown=builder src src
RUN cargo build --release --bins 2>&1

# Post-build install and configure, as root again

USER root
RUN install target/release/rectangle-device /usr/bin/rectangle-device

COPY --from=podman /usr/bin/podman /usr/bin/podman

COPY docker/nested-podman/containers.conf /etc/containers/containers.conf
COPY docker/nested-podman/storage.conf /etc/containers/storage.conf
COPY docker/nested-podman/policy.json /etc/containers/policy.json
COPY docker/nested-podman/registries.conf /etc/containers/registries.conf

# Pull initial set of transcode images as the app user

#xxx, testing podman as root inside the container
RUN podman pull docker.io/jrottenberg/ffmpeg:4.3.1-scratch38 2>&1
RUN podman run docker.io/jrottenberg/ffmpeg:4.3.1-scratch38 2>&1

USER rectangle-device
WORKDIR /home/rectangle-device
RUN podman pull docker.io/jrottenberg/ffmpeg:4.3.1-scratch38 2>&1

# Packaging the parts of this image we intend to keep

USER root
WORKDIR /
RUN tar chf - \
#
# App
usr/bin/rectangle-device \
home/rectangle-device \
#
# System binaries, as needed
bin/ls \
bin/ldd \
bin/openssl \
usr/bin/newuidmap \
#
# Podman container engine
usr/bin/podman \
usr/libexec/podman \
usr/bin/nsenter \
usr/bin/runsc \
etc/containers \
var/run/containers \
var/lib/containers \
#
# System data files
usr/share/zoneinfo \
usr/share/ca-certificates \
etc/ssl \
etc/passwd \
etc/group \
etc/shadow \
etc/subuid \
etc/subgid \
#
# Dynamic libraries, as needed
lib64 \
usr/lib64 \
lib/x86_64-linux-gnu/libc.so.6 \
lib/x86_64-linux-gnu/libm.so.6 \
lib/x86_64-linux-gnu/libtinfo.so.6 \
lib/x86_64-linux-gnu/libssl.so.1.1 \
lib/x86_64-linux-gnu/libcrypto.so.1.1 \
lib/x86_64-linux-gnu/libz.so.1 \
lib/x86_64-linux-gnu/libdl.so.2 \
lib/x86_64-linux-gnu/libpthread.so.0 \
lib/x86_64-linux-gnu/libgpgme.so.11 \
lib/x86_64-linux-gnu/libgcc_s.so.1 \
lib/x86_64-linux-gnu/libseccomp.so.2 \
lib/x86_64-linux-gnu/librt.so.1 \
lib/x86_64-linux-gnu/libassuan.so.0 \
lib/x86_64-linux-gnu/libgpg-error.so.0 \
lib/x86_64-linux-gnu/libyajl.so.2 \
lib/x86_64-linux-gnu/libsystemd.so.0 \
lib/x86_64-linux-gnu/liblzma.so.5 \
lib/x86_64-linux-gnu/liblz4.so.1 \
lib/x86_64-linux-gnu/libselinux.so.1 \
lib/x86_64-linux-gnu/libpcre2-8.so.0 \
lib/x86_64-linux-gnu/libgcrypt.so.20 \
lib/x86_64-linux-gnu/libglib-2.0.so.0 \
lib/x86_64-linux-gnu/libpcre.so.3 \
#
| ( \
  mkdir image && \
  cd image && \
  tar pxf - && \
  mkdir proc sys dev tmp var/tmp && \
  chmod 01777 tmp var/tmp \
)

FROM scratch
ARG DEFAULT_PATH
COPY --from=app /image/ /
WORKDIR /
ENV PATH ${DEFAULT_PATH}
USER rectangle-device
ENTRYPOINT [ "/usr/bin/rectangle-device" ]
CMD [ "--help" ]

# Incoming libp2p connections
EXPOSE 4004/tcp
