FROM 763104351884.dkr.ecr.us-west-2.amazonaws.com/tensorflow-training:2.3.2-gpu-py37-cu110-ubuntu18.04

LABEL maintainer="Amazon AI"
LABEL dlc_major_version="1"

# version args
ARG TRANSFORMERS_VERSION
ARG DATASETS_VERSION
ARG PYTHON=python3

# install Hugging Face libraries and its dependencies
RUN pip install --no-cache-dir \
    transformers[sklearn,sentencepiece]==${TRANSFORMERS_VERSION} \
    datasets \
    tensorflow-addons==0.12.0 \
    psutil
RUN apt-get update \
 && apt install --no-install-recommends -y git-lfs \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN HOME_DIR=/root \
 && curl -f -o ${HOME_DIR}/oss_compliance.zip https://aws-dlinfra-utilities.s3.amazonaws.com/oss_compliance.zip \
 && unzip ${HOME_DIR}/oss_compliance.zip -d ${HOME_DIR}/ \
 && cp ${HOME_DIR}/oss_compliance/test/testOSSCompliance /usr/local/bin/testOSSCompliance \
 && chmod +x /usr/local/bin/testOSSCompliance \
 && chmod +x ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh \
 && ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh ${HOME_DIR} ${PYTHON} \
 && rm -rf ${HOME_DIR}/oss_compliance*
