# Expecting base image to be the image built by ./Dockerfile.diy.cpu
ARG BASE_IMAGE=""

FROM $BASE_IMAGE

LABEL maintainer="Amazon AI"
LABEL dlc_major_version="1"

ARG PYTHON=python3
# Add arguments to achieve the version, python and url
ARG PYTHON_VERSION=3.8.10

# The smdebug pipeline relies for following format to perform string replace and trigger DLC pipeline for validating
# the nightly builds. Therefore, while updating the smdebug version, please ensure that the format is not disturbed.
ARG SMDEBUG_VERSION=1.0.9

ENV SAGEMAKER_TRAINING_MODULE=sagemaker_pytorch_container.training:main

WORKDIR /

# Copy workaround script for incorrect hostname
COPY changehostname.c /
COPY start_with_right_hostname.sh /usr/local/bin/start_with_right_hostname.sh

RUN pip install --no-cache-dir --upgrade pip --trusted-host pypi.org --trusted-host \
 && pip install --no-cache-dir -U \
    smdebug==${SMDEBUG_VERSION} \
    smclarify \
    "sagemaker>=2,<3" \
    sagemaker-experiments==0.* \
    "sagemaker-pytorch-training<3"

RUN chmod +x /usr/local/bin/start_with_right_hostname.sh

RUN HOME_DIR=/root \
 && curl -f -o ${HOME_DIR}/oss_compliance.zip https://aws-dlinfra-utilities.s3.amazonaws.com/oss_compliance.zip \
 && unzip ${HOME_DIR}/oss_compliance.zip -d ${HOME_DIR}/ \
 && cp ${HOME_DIR}/oss_compliance/test/testOSSCompliance /usr/local/bin/testOSSCompliance \
 && chmod +x /usr/local/bin/testOSSCompliance \
 && chmod +x ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh \
 && ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh ${HOME_DIR} ${PYTHON} \
 && rm -rf ${HOME_DIR}/oss_compliance* \
 && rm -rf /tmp/tmp

# Starts framework
ENTRYPOINT ["bash", "-m", "start_with_right_hostname.sh"]
CMD ["/bin/bash"]
