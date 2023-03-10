# Expecting base image to be the image built by ./Dockerfile.diy.gpu
ARG BASE_IMAGE=""

FROM $BASE_IMAGE

LABEL maintainer="Amazon AI"
LABEL dlc_major_version="1"

ENV SAGEMAKER_TRAINING_MODULE sagemaker_tensorflow_container.training:main

ARG PIP=pip3
ARG PYTHON=python3.7
ARG PYTHON_VERSION=3.7.10

# The smdebug pipeline relies for following format to perform string replace and trigger DLC pipeline for validating
# the nightly builds. Therefore, while updating the smdebug version, please ensure that the format is not disturbed.
ARG SMDEBUG_VERSION=1.0.9

ARG SMDATAPARALLEL_BINARY=https://smdataparallel.s3.amazonaws.com/binary/tensorflow/2.5.0/cu112/2021-06-21/smdistributed_dataparallel-1.2.1-cp37-cp37m-linux_x86_64.whl

ARG SMMODELPARALLEL_BINARY=https://sagemaker-distributed-model-parallel.s3.us-west-2.amazonaws.com/tensorflow-2.5.0/build-artifacts/2021-06-22-00-43/smdistributed_modelparallel-1.4.0-cp37-cp37m-linux_x86_64.whl

RUN ${PIP} install --no-cache-dir -U \
   "sagemaker>=2,<3" \
   sagemaker-experiments==0.* \
   "sagemaker-tensorflow>=2.5,<2.6" \
   "sagemaker-tensorflow-training>=20" \
   smdebug==${SMDEBUG_VERSION} \
   smclarify

# Install SMD MP binary
RUN pip install --no-cache-dir -U ${SMMODELPARALLEL_BINARY}

# Install SMD DP binary
RUN SMDATAPARALLEL_TF=1 ${PIP} install --no-cache-dir ${SMDATAPARALLEL_BINARY}

ENV LD_LIBRARY_PATH="/usr/local/lib/python3.7/site-packages/smdistributed/dataparallel/lib:$LD_LIBRARY_PATH"

RUN HOME_DIR=/root \
   && curl -f -o ${HOME_DIR}/oss_compliance.zip https://aws-dlinfra-utilities.s3.amazonaws.com/oss_compliance.zip \
   && unzip ${HOME_DIR}/oss_compliance.zip -d ${HOME_DIR}/ \
   && cp ${HOME_DIR}/oss_compliance/test/testOSSCompliance /usr/local/bin/testOSSCompliance \
   && chmod +x /usr/local/bin/testOSSCompliance \
   && chmod +x ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh \
   && ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh ${HOME_DIR} ${PYTHON} \
   && rm -rf ${HOME_DIR}/oss_compliance*

CMD ["/bin/bash"]
