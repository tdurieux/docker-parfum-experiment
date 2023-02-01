FROM bitnami/minideb-extras:stretch-r358
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/python/bin:/opt/bitnami/tensorflow-inception/bazel-bin/tensorflow_serving/example:$PATH"

# Install required system packages and dependencies
RUN install_packages libarchive-tools libbz2-1.0 libc6 libgcc1 libncurses5 libreadline7 libsqlite3-0 libssl1.1 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg install python-2.7.16-0 --checksum 1bd6ac396615c99f639a1b4755425accd03e0ec500e52bf068491cc0cac6d385
RUN bitnami-pkg unpack tensorflow-inception-1.11.1-20 --checksum 6d36ea0870371840bacd14803bab64f84747411406aebe14b19c6b42715e2e8e
RUN pip install --upgrade pip && \
    pip install enum34 futures mock numpy backports.weakref && \
    pip install Keras_Applications==1.0.5 Keras_Preprocessing==1.0.3 --no-deps && \
    pip install -i https://testpypi.python.org/simple --pre grpcio

COPY rootfs /
ENV BITNAMI_APP_NAME="tensorflow-inception" \
    BITNAMI_IMAGE_VERSION="1.11.1-debian-9-r137" \
    TENSORFLOW_INCEPTION_MODEL_INPUT_DATA_NAME="inception-v3" \
    TENSORFLOW_SERVING_HOST="tensorflow-serving" \
    TENSORFLOW_SERVING_PORT_NUMBER="8500"

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "tail", "-f", "/dev/null" ]
