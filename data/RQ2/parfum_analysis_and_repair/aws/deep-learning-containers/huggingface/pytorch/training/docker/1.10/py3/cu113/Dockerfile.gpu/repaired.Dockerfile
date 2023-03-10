# https://github.com/aws/deep-learning-containers/blob/master/available_images.md
# refer to the above page to pull latest Pytorch image

# docker image region us-west-2
FROM 763104351884.dkr.ecr.us-west-2.amazonaws.com/pytorch-training:1.10.2-gpu-py38-cu113-ubuntu20.04-sagemaker

LABEL maintainer="Amazon AI"
LABEL dlc_major_version="1"

# version args
ARG TRANSFORMERS_VERSION
ARG DATASETS_VERSION
ARG PYTHON=python3

# AWS packages
ARG PT_TORCHAUDIO_URL=https://framework-binaries.s3.us-west-2.amazonaws.com/pytorch/1.10.2/torchaudio-0.10.2%2Bcu113-cp38-cp38-linux_x86_64.whl
ARG SMD_MODEL_PARALLEL_URL=https://sagemaker-distributed-model-parallel.s3.us-west-2.amazonaws.com/pytorch-1.10.0/build-artifacts/2022-04-14-03-58/smdistributed_modelparallel-1.8.1-cp38-cp38-linux_x86_64.whl

# install Hugging Face libraries and its dependencies
RUN pip install --no-cache-dir \
	transformers[sklearn,sentencepiece,audio,vision]==${TRANSFORMERS_VERSION} \
	datasets==${DATASETS_VERSION} \
	$PT_TORCHAUDIO_URL

# TODO: remove when SMP 1.8 release in base image
# Uninstall and re-install sagemaker model parallelism libarry
RUN pip uninstall -y smdistributed-modelparallel \
 && pip install --no-cache-dir -U $SMD_MODEL_PARALLEL_URL


RUN apt-get update \
 # TODO: Remove upgrade statements once packages are updated in base image
 && apt-get -y upgrade --only-upgrade systemd openssl cryptsetup \
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
