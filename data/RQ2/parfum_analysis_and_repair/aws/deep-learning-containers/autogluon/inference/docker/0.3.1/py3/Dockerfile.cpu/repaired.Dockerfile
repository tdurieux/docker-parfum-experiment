FROM 763104351884.dkr.ecr.us-west-2.amazonaws.com/mxnet-inference:1.8.0-cpu-py37

# Specify accept-bind-to-port LABEL for inference pipelines to use SAGEMAKER_BIND_TO_PORT
# https://docs.aws.amazon.com/sagemaker/latest/dg/inference-pipeline-real-time.html
LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true
# Specify multi-models LABEL to indicate container is capable of loading and serving multiple models concurrently
# https://docs.aws.amazon.com/sagemaker/latest/dg/build-multi-model-build-container.html
LABEL com.amazonaws.sagemaker.capabilities.multi-models=true

LABEL maintainer="Amazon AI"
LABEL dlc_major_version="1"

ARG PYTHON_VERSION=3.7.10
ARG OPENSSL_VERSION=1.1.1l

RUN apt-get update \
 && apt-get -y upgrade \
 && apt-get autoremove -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# install OpenSSL
RUN wget -q -c https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz \
 && tar -xzf openssl-${OPENSSL_VERSION}.tar.gz \
 && cd openssl-${OPENSSL_VERSION} \
 && ./config && make -j $(nproc) && make install \
 && ldconfig \
 && cd .. && rm -rf openssl-* \
 && ln -s /etc/ssl/certs /usr/local/ssl/certs && rm openssl-${OPENSSL_VERSION}.tar.gz

ARG TORCH_VER=1.8.0+cpu
ARG TORCH_VISION_VER=0.9.0+cpu
ARG NUMPY_VER=1.19.5
ARG AUTOGLUON_VERSION=0.3.1

RUN pip --no-cache-dir install --upgrade --trusted-host pypi.org --trusted-host files.pythonhosted.org pip \
 && pip --no-cache-dir install --upgrade wheel setuptools \
 && pip uninstall -y dataclasses \
 && pip install --no-cache-dir -U torch==${TORCH_VER} torchvision==${TORCH_VISION_VER} -f https://download.pytorch.org/whl/torch_stable.html \
    numpy==${NUMPY_VER} \
    autogluon==${AUTOGLUON_VERSION}

# Catboost 0.26 updates version of scala 2.11 for security reasons
# https://github.com/catboost/catboost/issues/1632
# The package pillow from 5.2.0 and before 8.3.2 is vulnerable to Regular Expression Denial of Service (ReDoS) via the getrgb function.                |
# Dask security patching
RUN pip install --no-cache-dir -U catboost==0.26.1 \
 && pip install --no-cache-dir -U "dask>2021.09.1" "distributed>2021.09.1" \
 && pip install --no-cache-dir -U 'Pillow>=8.3.2,<8.4.0'

EXPOSE 8080 8081
ENTRYPOINT ["python", "/usr/local/bin/dockerd-entrypoint.py"]
CMD ["multi-model-server", "--start", "--mms-config", "/home/model-server/config.properties"]
