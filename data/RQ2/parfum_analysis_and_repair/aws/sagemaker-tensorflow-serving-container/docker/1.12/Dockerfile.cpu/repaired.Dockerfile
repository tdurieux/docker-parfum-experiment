ARG TFS_VERSION

FROM tensorflow/serving:${TFS_VERSION} as tfs
FROM ubuntu:16.04
LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true

COPY --from=tfs /usr/bin/tensorflow_model_server /usr/bin/tensorflow_model_server

# nginx + njs
RUN \
    apt-get update && \
    apt-get -y install --no-install-recommends curl && \
    curl -f -s https://nginx.org/keys/nginx_signing.key | apt-key add - && \
    echo 'deb http://nginx.org/packages/ubuntu/ xenial nginx' >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y install --no-install-recommends nginx nginx-module-njs python3 python3-pip python3-setuptools && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

# cython, falcon, gunicorn, tensorflow-serving
RUN \
    pip3 install --no-cache-dir cython falcon gunicorn gevent requests grpcio protobuf && \
    pip3 install --no-dependencies --no-cache-dir tensorflow-serving-api==1.12.0

COPY ./ /

ARG TFS_SHORT_VERSION
ENV SAGEMAKER_TFS_VERSION "${TFS_SHORT_VERSION}"
ENV PATH "$PATH:/sagemaker"
