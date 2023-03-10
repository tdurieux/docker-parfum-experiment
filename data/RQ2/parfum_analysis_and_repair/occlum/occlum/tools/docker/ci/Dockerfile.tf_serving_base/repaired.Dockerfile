FROM tensorflow/serving:latest-devel as binary_build
LABEL maintainer="Zehuan Li <lizehuan.lzh@antgroup.com>"
WORKDIR /tensorflow-serving
# Build, and install TensorFlow Serving
ARG TF_SERVING_BUILD_OPTIONS="--config=nativeopt"
RUN echo "Building with build options: ${TF_SERVING_BUILD_OPTIONS}"
ARG TF_SERVING_BAZEL_OPTIONS=""
RUN echo "Building with Bazel options: ${TF_SERVING_BAZEL_OPTIONS}"

RUN bazel build -j 8 --color=yes --curses=yes \
    ${TF_SERVING_BAZEL_OPTIONS} \
    --verbose_failures \
    --force_pic \
    --output_filter=DONT_MATCH_ANYTHING \
    ${TF_SERVING_BUILD_OPTIONS} \
    tensorflow_serving/model_servers:tensorflow_model_server && \
    cp bazel-bin/tensorflow_serving/model_servers/tensorflow_model_server \
    /usr/local/bin/

# Build and install TensorFlow Serving API
RUN bazel build -j 8 --color=yes --curses=yes \
    ${TF_SERVING_BAZEL_OPTIONS} \
    --force_pic \
    --verbose_failures \
    --output_filter=DONT_MATCH_ANYTHING \
    ${TF_SERVING_BUILD_OPTIONS} \
    tensorflow_serving/tools/pip_package:build_pip_package && \
    bazel-bin/tensorflow_serving/tools/pip_package/build_pip_package \
    /tmp/pip && \
    pip --no-cache-dir install --upgrade \
    /tmp/pip/tensorflow_serving_api-*.whl && \
    rm -rf /tmp/pip

RUN cp -r /usr/local/bin/tensorflow_model_server /root/tensorflow_model_server

WORKDIR /root