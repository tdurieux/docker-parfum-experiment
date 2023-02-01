#
# Docker file for AppStream CI tests on Debian Stable
#
FROM debian:bullseye

# prepare
RUN mkdir -p /build/ci/

# install build dependencies
COPY install-deps-deb.sh /build/ci/
RUN chmod +x /build/ci/install-deps-deb.sh && /build/ci/install-deps-deb.sh

RUN eatmydata apt-get install -yq --no-install-recommends python3-pip
RUN pip install --no-cache-dir 'meson~=0.62'

# finish
WORKDIR /build
