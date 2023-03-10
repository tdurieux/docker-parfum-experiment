ARG ENVOY_BUILD_IMAGE
FROM $ENVOY_BUILD_IMAGE

ARG BUILD_CMD

RUN groupadd --gid $(id -g) -f envoygroup \
  && useradd -o --uid $(id -u) --gid $(id -g) --no-create-home --home-dir /build envoybuild \
  && usermod -a -G pcap envoybuild \
  && mkdir /build /source \
  && chown envoybuild:envoygroup /build /source

COPY . /envoy-sources/

RUN sudo -EHs -u envoybuild bash -c "pushd /envoy-sources && bazel/setup_clang.sh /opt/llvm"
RUN sudo -EHs -u envoybuild bash -c "pushd /envoy-sources && $BUILD_CMD"
RUN sudo -EHs -u envoybuild bash -c "pushd /envoy-sources/bazel-bin/contrib/exe && strip envoy-static -o envoy"