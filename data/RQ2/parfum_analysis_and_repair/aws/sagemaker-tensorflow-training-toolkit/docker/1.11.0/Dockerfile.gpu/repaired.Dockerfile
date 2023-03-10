FROM nvidia/cuda:9.0-base-ubuntu16.04

LABEL maintainer="Amazon AI"

ARG framework_installable
ARG framework_support_installable=sagemaker_tensorflow_container-2.0.0.tar.gz
ARG py_version

# Validate that arguments are specified
RUN test $framework_installable || exit 1 \
    && test $py_version || exit 1

RUN apt-get update && apt-get install -y --no-install-recommends software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa -y \
    && rm -rf /var/lib/apt/lists/*

ENV NCCL_VERSION=2.3.5-2+cuda9.0
ENV CUDNN_VERSION=7.3.1.20-1+cuda9.0
ENV TF_TENSORRT_VERSION=4.1.2

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        cuda-command-line-tools-9-0 \
        cuda-cublas-dev-9-0 \
        cuda-cudart-dev-9-0 \
        cuda-cufft-dev-9-0 \
        cuda-curand-dev-9-0 \
        cuda-cusolver-dev-9-0 \
        cuda-cusparse-dev-9-0 \
        curl \
        libcudnn7=${CUDNN_VERSION} \
        libnccl2=${NCCL_VERSION} \
        libgomp1 \
    # The 'apt-get install' of nvinfer-runtime-trt-repo-ubuntu1604-4.0.1-ga-cuda9.0
    # adds a new list which contains libnvinfer library, so it needs another
    # 'apt-get update' to retrieve that list before it can actually install the
    # library.
    # We don't install libnvinfer-dev since we don't need to build against TensorRT,
    # and libnvinfer4 doesn't contain libnvinfer.a static library.
    && apt-get update && apt-get install -y --no-install-recommends \
        nvinfer-runtime-trt-repo-ubuntu1604-4.0.1-ga-cuda9.0 \
    && apt-get update && apt-get install -y --no-install-recommends \
        libnvinfer4=${TF_TENSORRT_VERSION}-1+cuda9.0 \
    && apt-get clean \
    && rm /usr/lib/x86_64-linux-gnu/libnvinfer_plugin* \
    && rm /usr/lib/x86_64-linux-gnu/libnvcaffe_parser* \
    && rm /usr/lib/x86_64-linux-gnu/libnvparsers* \
    && if [ $py_version -eq 3 ]; \
           then apt-get install -y --no-install-recommends python3.6-dev \
                && ln -s -f /usr/bin/python3.6 /usr/bin/python; \
           else apt-get install -y --no-install-recommends python-dev; fi \
    && rm -rf /var/lib/apt/lists/*

# Python won???t try to write .pyc or .pyo files on the import of source modules
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1

RUN curl -fSsL -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py \
		    --disable-pip-version-check \
		    --no-cache-dir \
		    "pip==18.1" \
	; \
	pip --version; \
	find /usr/local -depth \
		\( \
			\( -type d -a \( -name test -o -name tests \) \) \
			-o \
			\( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
		\) -exec rm -rf '{}' +; \
    rm get-pip.py

WORKDIR /

COPY $framework_installable .
COPY $framework_support_installable .

RUN pip install --no-cache-dir -U \
    keras==2.2.4 \
    $framework_support_installable \
    "sagemaker-tensorflow>=1.11,<1.12" \
    # Let's install TensorFlow separately in the end to avoid
    # the library version to be overwritten
    && pip install --force-reinstall --no-cache-dir -U $framework_installable \
    \
    && rm -f $framework_installable \
    && rm -f $framework_support_installable \
    && pip uninstall -y --no-cache-dir \
    markdown \
    tensorboard

ENV SAGEMAKER_TRAINING_MODULE sagemaker_tensorflow_container.training:main