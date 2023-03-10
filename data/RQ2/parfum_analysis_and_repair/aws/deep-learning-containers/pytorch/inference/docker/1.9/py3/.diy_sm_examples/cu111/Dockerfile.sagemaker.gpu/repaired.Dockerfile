# Expecting base image to be the image built by ./Dockerfile.diy.gpu
ARG BASE_IMAGE=""

FROM $BASE_IMAGE

LABEL maintainer="Amazon AI"
LABEL dlc_major_version="1"

LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true

ARG PYTHON=python3
ARG PYTHON_VERSION=3.8.10

ENV SAGEMAKER_SERVING_MODULE sagemaker_pytorch_serving_container.serving:main

RUN pip install --no-cache-dir "sagemaker-pytorch-inference>=2"

RUN HOME_DIR=/root \
 && curl -f -o ${HOME_DIR}/oss_compliance.zip https://aws-dlinfra-utilities.s3.amazonaws.com/oss_compliance.zip \
 && unzip ${HOME_DIR}/oss_compliance.zip -d ${HOME_DIR}/ \
 && cp ${HOME_DIR}/oss_compliance/test/testOSSCompliance /usr/local/bin/testOSSCompliance \
 && chmod +x /usr/local/bin/testOSSCompliance \
 && chmod +x ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh \
 && ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh ${HOME_DIR} ${PYTHON} \
 && rm -rf ${HOME_DIR}/oss_compliance*

EXPOSE 8080 8081
CMD ["torchserve", "--start", "--ts-config", "/home/model-server/config.properties", "--model-store", "/home/model-server/"]
