# Expecting base image to be the image built by ./Dockerfile.diy.cpu
ARG BASE_IMAGE=""

FROM $BASE_IMAGE

LABEL maintainer="Amazon AI"
LABEL dlc_major_version="1"

ENV SAGEMAKER_TRAINING_MODULE sagemaker_tensorflow_container.training:main

ARG PYTHON=python3.7
ARG PIP=pip3
ARG PYTHON_VERSION=3.7.10

# The smdebug pipeline relies for following format to perform string replace and trigger DLC pipeline for validating
# the nightly builds. Therefore, while updating the smdebug version, please ensure that the format is not disturbed.
ARG SMDEBUG_VERSION=1.0.9

RUN ${PIP} install --no-cache-dir -U \
    "sagemaker>=2,<3" \
    sagemaker-experiments==0.* \
    "sagemaker-tensorflow>=2.5,<2.6" \
    "sagemaker-tensorflow-training>=20" \
    smdebug==${SMDEBUG_VERSION} \
    smclarify

RUN HOME_DIR=/root \
   && curl -f -o ${HOME_DIR}/oss_compliance.zip https://aws-dlinfra-utilities.s3.amazonaws.com/oss_compliance.zip \
   && unzip ${HOME_DIR}/oss_compliance.zip -d ${HOME_DIR}/ \
   && cp ${HOME_DIR}/oss_compliance/test/testOSSCompliance /usr/local/bin/testOSSCompliance \
   && chmod +x /usr/local/bin/testOSSCompliance \
   && chmod +x ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh \
   && ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh ${HOME_DIR} ${PYTHON} \
   && rm -rf ${HOME_DIR}/oss_compliance*

CMD ["/bin/bash"]
