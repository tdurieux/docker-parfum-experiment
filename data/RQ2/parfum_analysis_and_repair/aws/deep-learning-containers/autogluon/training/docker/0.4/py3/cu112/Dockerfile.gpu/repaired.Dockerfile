ARG CUDA_VER=11.2
ARG PYTHON_VERSION=3.8.10

FROM 763104351884.dkr.ecr.us-west-2.amazonaws.com/mxnet-training:1.9.0-gpu-py38-cu112-ubuntu20.04-sagemaker

ENV MXNET_CUDNN_LIB_CHECKING=0 \
    MXNET_CUDNN_AUTOTUNE_DEFAULT=0

LABEL maintainer="Amazon AI"
LABEL dlc_major_version="1"

RUN apt-get update \
 && apt-get -y upgrade \
 && apt-get install -y --no-install-recommends \
    libgl1-mesa-glx \
    ffmpeg \
    libsm6 \
    libxext6 \
 && apt-get autoremove -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/*

ARG AUTOGLUON_VERSION=0.4.2

# Pinning setuptools because it's breaking pip
RUN pip install --no-cache-dir -U --trusted-host pypi.org --trusted-host files.pythonhosted.org pip \
 && pip install --no-cache-dir -U setuptools==59.5.0 wheel \
 && pip install --no-cache-dir -U numba \
 && pip install --no-cache-dir -U autogluon==${AUTOGLUON_VERSION} \
 && pip install --no-cache-dir -U sagemaker-mxnet-training

# Resolving sagemaker 2.92.1 conflict
RUN pip install --no-cache-dir 'importlib-metadata<2.0,>=1.4.0' markdown

RUN HOME_DIR=/root \
 && curl -f -o ${HOME_DIR}/oss_compliance.zip https://aws-dlinfra-utilities.s3.amazonaws.com/oss_compliance.zip \
 && unzip ${HOME_DIR}/oss_compliance.zip -d ${HOME_DIR}/ \
 && cp ${HOME_DIR}/oss_compliance/test/testOSSCompliance /usr/local/bin/testOSSCompliance \
 && chmod +x /usr/local/bin/testOSSCompliance \
 && chmod +x ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh \
 && ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh ${HOME_DIR} python \
 && rm -rf ${HOME_DIR}/oss_compliance*

RUN curl -f -o /licenses-autogluon.txt https://autogluon.s3.us-west-2.amazonaws.com/licenses/THIRD-PARTY-LICENSES.txt

CMD ["/bin/bash"]
