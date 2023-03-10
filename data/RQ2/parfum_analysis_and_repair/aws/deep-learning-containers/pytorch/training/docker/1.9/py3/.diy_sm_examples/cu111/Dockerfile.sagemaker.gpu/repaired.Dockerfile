# Expecting base image to be the image built by ./Dockerfile.diy.gpu
ARG BASE_IMAGE=""

FROM $BASE_IMAGE

LABEL maintainer="Amazon AI"
LABEL dlc_major_version="1"

ARG PYTHON=python3
ARG PYTHON_VERSION=3.8.10
ARG PYTHON_SHORT_VERSION=3.8
ARG CONDA_PREFIX=/opt/conda

# The smdebug pipeline relies for following format to perform string replace and trigger DLC pipeline for validating
# the nightly builds. Therefore, while updating the smdebug version, please ensure that the format is not disturbed.
ARG SMDEBUG_VERSION=1.0.9

ENV SAGEMAKER_TRAINING_MODULE=sagemaker_pytorch_container.training:main

ARG SMD_MODEL_PARALLEL_URL=https://sagemaker-distributed-model-parallel.s3.us-west-2.amazonaws.com/pytorch-1.9.0/build-artifacts/2021-06-29-16-48/smdistributed_modelparallel-1.4.0-cp38-cp38-linux_x86_64.whl
ARG SMDATAPARALLEL_BINARY=https://smdataparallel.s3.amazonaws.com/binary/pytorch/1.9.0/cu111/2021-08-13/smdistributed_dataparallel-1.2.0-cp38-cp38-linux_x86_64.whl

# Install libboost from source. This package is needed for smdataparallel functionality [for networking asynchronous IO].
RUN wget https://sourceforge.net/projects/boost/files/boost/1.73.0/boost_1_73_0.tar.gz/download -O boost_1_73_0.tar.gz \
  && tar -xzf boost_1_73_0.tar.gz \
  && cd boost_1_73_0 \
  && ./bootstrap.sh \
  && ./b2 threading=multi --prefix=${CONDA_PREFIX} -j 64 cxxflags=-fPIC cflags=-fPIC install || true \
  && cd .. \
  && rm -rf boost_1_73_0.tar.gz \
  && rm -rf boost_1_73_0 \
  && cd ${CONDA_PREFIX}/include/boost

WORKDIR /opt/pytorch

# Copy workaround script for incorrect hostname
COPY changehostname.c /
COPY start_with_right_hostname.sh /usr/local/bin/start_with_right_hostname.sh

WORKDIR /root

RUN pip install --no-cache-dir -U \
    smdebug==${SMDEBUG_VERSION} \
    smclarify \
    "sagemaker>=2,<3" \
    sagemaker-experiments==0.* \
    sagemaker-pytorch-training

# Install SM Distributed Modelparallel binary
RUN pip install --no-cache-dir -U ${SMD_MODEL_PARALLEL_URL}

# Install SM Distributed DataParallel binary
RUN SMDATAPARALLEL_PT=1 pip install --no-cache-dir ${SMDATAPARALLEL_BINARY}

ENV LD_LIBRARY_PATH="/opt/conda/lib/python${PYTHON_SHORT_VERSION}/site-packages/smdistributed/dataparallel/lib:$LD_LIBRARY_PATH"

WORKDIR /

RUN chmod +x /usr/local/bin/start_with_right_hostname.sh

RUN HOME_DIR=/root \
 && curl -f -o ${HOME_DIR}/oss_compliance.zip https://aws-dlinfra-utilities.s3.amazonaws.com/oss_compliance.zip \
 && unzip ${HOME_DIR}/oss_compliance.zip -d ${HOME_DIR}/ \
 && cp ${HOME_DIR}/oss_compliance/test/testOSSCompliance /usr/local/bin/testOSSCompliance \
 && chmod +x /usr/local/bin/testOSSCompliance \
 && chmod +x ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh \
 && ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh ${HOME_DIR} ${PYTHON} \
 && rm -rf ${HOME_DIR}/oss_compliance* \
 && rm -rf /tmp/tmp*

# Starts framework
ENTRYPOINT ["bash", "-m", "start_with_right_hostname.sh"]
CMD ["/bin/bash"]
