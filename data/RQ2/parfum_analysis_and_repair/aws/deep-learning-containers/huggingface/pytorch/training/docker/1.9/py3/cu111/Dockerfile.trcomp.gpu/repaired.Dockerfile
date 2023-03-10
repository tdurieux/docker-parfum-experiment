# https://github.com/aws/deep-learning-containers/blob/master/available_images.md
# refer to the above page to pull latest Pytorch image

# docker image region us-west-2
FROM 763104351884.dkr.ecr.us-west-2.amazonaws.com/pytorch-training:1.9-gpu-py38-cu111-ubuntu20.04-v1

LABEL maintainer="Amazon AI"
LABEL dlc_major_version="1"

# version args
ARG TRANSFORMERS_VERSION
ARG DATASETS_VERSION
ARG PYTHON=python3

# Install  Sagemaker PythonSDK
ARG SAGEMAKER_BINARY

COPY ${SAGEMAKER_BINARY} .

# Install Sagemaker PythonSDK
RUN pip install --no-cache-dir sagemaker


# Artifact URLs
ARG ARTIFACT_BUCKET=https://sm-training-comp-pytorch-binaries.s3.us-west-2.amazonaws.com
ARG PT_PREFIX=8e3374f1-7fd0-4909-acc0-7d00f2ba52b5/20220120-035850/f8595cb4308f6cf9856beebb39e6bed5ddd38f6a
ARG PT_URL=${ARTIFACT_BUCKET}/${PT_PREFIX}/torch-1.9.0-cp38-cp38-linux_x86_64.whl
ARG PT_XLA_URL=${ARTIFACT_BUCKET}/${PT_PREFIX}/torch_xla-1.10%2Bf8595cb-cp38-cp38-linux_x86_64.whl
ARG TORCHVISION_URL=${ARTIFACT_BUCKET}/${PT_PREFIX}/torchvision-0.10.0a0%2B6e72416-cp38-cp38-linux_x86_64.whl
ARG HF_PREFIX=v4.11.0_aws/20211111-201203/e5c0ba2158ef44f1a15f2d58dc5f0e17e4678242
ARG HF_TRANSFORMERS_URL=${ARTIFACT_BUCKET}/${HF_PREFIX}/transformers-4.11.0-py3-none-any.whl

# install Hugging Face libraries and its dependencies
RUN pip install -U --no-cache-dir \ 
	transformers[sklearn,sentencepiece]==${TRANSFORMERS_VERSION} \ 
	datasets==${DATASETS_VERSION} \
	# TODO: Remove upgrade statements once packages are updated in base image
	"Pillow>=8.3.2" \
    "bokeh>=2.4.2" \
    "numpy>=1.22.0" \
    "ipython>=7.31.1" \
    "opencv-python>=4.6,<5"

RUN apt-get update \
 # TODO: Remove upgrade statements once packages are updated in base image
 && apt-get -y upgrade --only-upgrade systemd openssl \
 && apt install --no-install-recommends -y git-lfs \
 && apt install --no-install-recommends -y libomp5 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install PyTorch

RUN pip uninstall -y torch\
 && pip install --no-deps --no-cache-dir -U --force-reinstall ${PT_URL}

# Install PyTorch XLA

RUN pip uninstall -y torch_xla \
 && pip install --no-deps --no-cache-dir -U --force-reinstall ${PT_XLA_URL}

# Install TorchVision

RUN pip uninstall -y torchvision \
 && pip install --no-deps --no-cache-dir -U --force-reinstall ${TORCHVISION_URL}

# Install Tranformers

RUN pip uninstall -y transformers \
 && pip install --no-deps --no-cache-dir --force-reinstall -U ${HF_TRANSFORMERS_URL}

# Fix library links
ARG CONDA_PREFIX=/opt/conda

RUN ln -s ${CONDA_PREFIX}/lib/libmkl_intel_lp64.so ${CONDA_PREFIX}/lib/libmkl_intel_lp64.so.1 \
 && ln -s ${CONDA_PREFIX}/lib/libmkl_intel_thread.so ${CONDA_PREFIX}/lib/libmkl_intel_thread.so.1 \
 && ln -s ${CONDA_PREFIX}/lib/libmkl_core.so ${CONDA_PREFIX}/lib/libmkl_core.so.1

# Install Numpy
ARG NUMPY_VERSION=1.20
RUN ${CONDA_PREFIX}/bin/conda install -y -c anaconda numpy=${NUMPY_VERSION}

# Install Horovod
ENV HOROVOD_VERSION=0.21.3
RUN pip uninstall -y horovod \
 && ldconfig /usr/local/cuda-11.1/targets/x86_64-linux/lib/stubs \
 && HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_CUDA_HOME=/usr/local/cuda-11.1 HOROVOD_WITH_PYTORCH=1 pip install --no-cache-dir horovod==${HOROVOD_VERSION} \
 && ldconfig

RUN HOME_DIR=/root \
 && curl -f -o ${HOME_DIR}/oss_compliance.zip https://aws-dlinfra-utilities.s3.amazonaws.com/oss_compliance.zip \
 && unzip ${HOME_DIR}/oss_compliance.zip -d ${HOME_DIR}/ \
 && cp ${HOME_DIR}/oss_compliance/test/testOSSCompliance /usr/local/bin/testOSSCompliance \
 && chmod +x /usr/local/bin/testOSSCompliance \
 && chmod +x ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh \
 && ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh ${HOME_DIR} ${PYTHON} \
 && rm -rf ${HOME_DIR}/oss_compliance*
