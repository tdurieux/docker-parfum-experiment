FROM ubuntu:16.04

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

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    build-essential \
    curl \
    nginx \
    && if [ $py_version -eq 3 ]; \
       then apt-get install -y --no-install-recommends python3.6-dev \
           && ln -s -f /usr/bin/python3.6 /usr/bin/python; \
       else apt-get install -y --no-install-recommends python-dev; fi \
    && rm -rf /var/lib/apt/lists/*

# Python won’t try to write .pyc or .pyo files on the import of source modules
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

# Set environment variables for MKL
# TODO: investigate the right value for OMP_NUM_THREADS
# For more about MKL with TensorFlow see:
# https://www.tensorflow.org/performance/performance_guide#tensorflow_with_intel%C2%AE_mkl_dnn
ENV KMP_AFFINITY=granularity=fine,compact,1,0 KMP_BLOCKTIME=1 KMP_SETTINGS=0

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