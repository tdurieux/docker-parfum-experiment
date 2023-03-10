FROM ubuntu:16.04
LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true

ARG PIP=pip3
ARG TFS_SHORT_VERSION

ENV SAGEMAKER_TFS_VERSION="${TFS_SHORT_VERSION}"
ENV PATH="$PATH:/sagemaker"

# nginx + njs
RUN apt-get update \
 && apt-get -y install --no-install-recommends curl gnupg2 \
 && curl -f -s https://nginx.org/keys/nginx_signing.key | apt-key add - \
 && echo 'deb http://nginx.org/packages/ubuntu/ xenial nginx' >> /etc/apt/sources.list \
 && apt-get update \
 && apt-get -y install --no-install-recommends nginx nginx-module-njs python3 python3-pip python3-setuptools \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# cython, falcon, gunicorn, grpc
RUN ${PIP} install --no-cache-dir \
    awscli==1.16.130 \
    cython==0.29.10 \
    falcon==2.0.0 \
    gunicorn==19.9.0 \
    gevent==1.4.0 \
    requests==2.21.0 \
    grpcio==1.24.1 \
    protobuf==3.10.0 \
# using --no-dependencies to avoid installing tensorflow binary
 && ${PIP} install --no-dependencies --no-cache-dir \
    tensorflow-serving-api==1.13.0

COPY ./ /

RUN mv amazonei_tensorflow_model_server /usr/bin/tensorflow_model_server && \
    chmod +x /usr/bin/tensorflow_model_server
