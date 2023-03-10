# https://github.com/aws/deep-learning-containers/blob/master/available_images.md
# refer to the above page to pull latest Tensorflow image

# docker image region us-west-2
FROM 763104351884.dkr.ecr.us-west-2.amazonaws.com/tensorflow-training:2.6-gpu-py38

LABEL maintainer="Amazon AI"
LABEL dlc_major_version="1"

# version args
ARG TRANSFORMERS_VERSION
ARG DATASETS_VERSION
ARG PYTHON=python3

ARG TF_BUCKET=https://framework-binaries.s3.us-west-2.amazonaws.com/tensorflow/trcomp/r2.6_aws/gpu/2022-03-20-05-33
ARG TF_URL=${TF_BUCKET}/tensorflow_gpu-2.6.3-cp38-cp38-manylinux_2_12_x86_64.manylinux2010_x86_64.whl

# Install  Sagemaker PythonSDK
RUN pip install --no-cache-dir sagemaker

# uninstall ipython jupyter utils due to incompatibility with typing-extensions==3.7.4.3
# https://github.com/huggingface/huggingface_hub/blob/main/setup.py:19
RUN pip uninstall -y IPython sparkmagic jupyter-console ipywidgets ipykernel hdijupyterutils jupyter sagemaker-studio-analytics-extension qtconsole notebook autovizwidget widgetsnbextension

# install Hugging Face libraries and its dependencies
RUN pip install --no-cache-dir \
    transformers[sklearn,sentencepiece]==${TRANSFORMERS_VERSION} \
    datasets==${DATASETS_VERSION} \
    tensorflow-addons==0.12.0 \
    psutil \
    "typing-extensions==3.7.4.3" \
    # bokeh 2.3.3 is the latest compatible version for typing-extensions 3.7.4.3
    "bokeh==2.3.3"

RUN apt-get update \
 # TODO: Remove upgrade statements once packages are updated in base image
 && apt-get -y upgrade --only-upgrade systemd openssl \
 && apt install --no-install-recommends -y git-lfs \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install TensorFlow
RUN pip uninstall -y tensorflow-gpu \
 && pip install --no-deps --no-cache-dir -U --force-reinstall ${TF_URL} \
 && pip install --no-cache-dir -U "numpy<1.22"

# Install Horovod
RUN ldconfig /usr/local/cuda-11.2/targets/x86_64-linux/lib/stubs \
 && HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_WITH_TENSORFLOW=1 pip install --no-cache-dir horovod==0.22.1 \
 && ldconfig

RUN HOME_DIR=/root \
 && curl -f -o ${HOME_DIR}/oss_compliance.zip https://aws-dlinfra-utilities.s3.amazonaws.com/oss_compliance.zip \
 && unzip ${HOME_DIR}/oss_compliance.zip -d ${HOME_DIR}/ \
 && cp ${HOME_DIR}/oss_compliance/test/testOSSCompliance /usr/local/bin/testOSSCompliance \
 && chmod +x /usr/local/bin/testOSSCompliance \
 && chmod +x ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh \
 && ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh ${HOME_DIR} ${PYTHON} \
 && rm -rf ${HOME_DIR}/oss_compliance*
