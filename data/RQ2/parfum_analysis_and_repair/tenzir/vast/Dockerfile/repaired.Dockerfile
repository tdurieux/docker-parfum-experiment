# -- dependencies --------------------------------------------------------------

FROM debian:bullseye-slim AS dependencies
LABEL maintainer="engineering@tenzir.com"

ENV CC="gcc-10" \
    CXX="g++-10"

WORKDIR /tmp/vast

RUN apt-get update && \
    apt-get -y --no-install-recommends install \
      build-essential \
      ca-certificates \
      cmake \
      flatbuffers-compiler-dev \
      g++-10 \
      gcc-10 \
      git-core \
      gnupg2 \
      jq \
      libcaf-dev \
      libbroker-dev \
      libflatbuffers-dev \
      libfmt-dev \
      libpcap-dev tcpdump \
      libsimdjson-dev \
      libspdlog-dev \
      libssl-dev \
      libunwind-dev \
      libyaml-cpp-dev \
      libxxhash-dev \
      lsb-release \
      ninja-build \
      pkg-config \
      python3-dev \
      python3-pip \
      python3-venv \
      robin-map-dev \
      wget && \
    wget "https://apache.jfrog.io/artifactory/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb" && \
    apt-get -y --no-install-recommends install \
      ./apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb && \
    apt-get update && \
    apt-get -y --no-install-recommends install libarrow-dev libprotobuf-dev && \
    rm -rf /var/lib/apt/lists/* *.deb

# VAST
COPY changelog ./changelog
COPY cmake ./cmake
COPY examples ./examples
COPY libvast ./libvast
COPY libvast_test ./libvast_test
COPY plugins ./plugins
COPY schema ./schema
COPY scripts ./scripts
COPY tools ./tools
COPY vast ./vast
COPY BANNER CMakeLists.txt LICENSE VAST.spdx README.md VERSIONING.md \
     vast.yaml.example ./

# Resolve repository-internal symlinks.
# TODO: We should try to get rid of these long-term, as Docker does not work
# well with repository-internal symlinks. The pyvast symlink is unnecessary, and
# the integration test symlinks we can get rid of by copying the integration
# test directory to the build directory when building VAST.
RUN ln -sf ../../pyvast/pyvast examples/jupyter/pyvast && \
    ln -sf ../../vast.yaml.example vast/integration/vast.yaml.example && \
    ln -sf ../../vast/integration/data/ plugins/pcap/data/ && \
    ln -sf ../../vast/integration/data/ plugins/sigma/integration/data/ && \
    ln -sf ../vast/integration/misc/scripts/print-arrow.py scripts/print-arrow.py && \
    ln -sf ../../../schema/types/base.schema libvast_test/artifacts/schemas/base.schema && \
    ln -sf ../../../schema/types/suricata.schema libvast_test/artifacts/schemas/suricata.schema

# -- development ---------------------------------------------------------------

FROM dependencies AS development

ENV PREFIX="/opt/tenzir/vast" \
    PATH="/opt/tenzir/vast/bin:${PATH}" \
    CC="gcc-10" \
    CXX="g++-10"

# Additional arguments to be passed to CMake.
ARG VAST_BUILD_OPTIONS

RUN cmake -B build -G Ninja \
      ${VAST_BUILD_OPTIONS} \
      -D CMAKE_INSTALL_PREFIX:STRING="$PREFIX" \
      -D CMAKE_BUILD_TYPE:STRING="Release" \
      -D VAST_ENABLE_UNIT_TESTS:BOOL="OFF" \
      -D VAST_ENABLE_DEVELOPER_MODE:BOOL="OFF" \
      -D VAST_ENABLE_MANPAGES:BOOL="OFF" \
      -D VAST_PLUGINS:STRING="plugins/*" && \
    cmake --build build --parallel && \
    cmake --install build --strip && \
    rm -rf build

RUN mkdir -p $PREFIX/etc/vast /var/log/vast /var/lib/vast
COPY systemd/vast.yaml $PREFIX/etc/vast/vast.yaml

EXPOSE 42000/tcp

WORKDIR /var/lib/vast
VOLUME ["/var/lib/vast"]

ENTRYPOINT ["vast"]
CMD ["--help"]

# -- production ----------------------------------------------------------------