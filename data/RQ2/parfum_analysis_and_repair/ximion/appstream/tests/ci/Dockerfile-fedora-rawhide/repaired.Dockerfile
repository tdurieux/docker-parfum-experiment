#
# Docker file for AppStream CI tests on Fedora Rawhide
#
FROM registry.fedoraproject.org/fedora:rawhide

# prepare
RUN mkdir -p /build/ci/

# install build dependencies
COPY install-deps-rpm.sh /build/ci/
RUN chmod +x /build/ci/install-deps-rpm.sh && /build/ci/install-deps-rpm.sh

RUN dnf --assumeyes --quiet --setopt=install_weak_deps=False install python3-pip
RUN pip install --no-cache-dir 'meson~=0.62'

# finish
WORKDIR /build
