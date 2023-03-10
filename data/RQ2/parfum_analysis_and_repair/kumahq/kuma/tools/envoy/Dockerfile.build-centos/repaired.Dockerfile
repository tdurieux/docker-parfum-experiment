ARG ENVOY_BUILD_IMAGE
FROM $ENVOY_BUILD_IMAGE

ARG BUILD_CMD

COPY . /envoy-sources/

RUN bash -c "pushd envoy-sources/ && bazel/setup_clang.sh /opt/llvm"
RUN bash -c "pushd /envoy-sources && $BUILD_CMD"
RUN bash -c "pushd /envoy-sources/bazel-bin/contrib/exe && strip envoy-static -o envoy"