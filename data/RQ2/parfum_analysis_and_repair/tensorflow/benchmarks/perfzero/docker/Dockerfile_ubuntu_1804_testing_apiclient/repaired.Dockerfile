# Ubuntu 18.04 Python3 with CUDA 10.1 and the following:
#  - Installs tf-nightly-gpu (this is TF 2.1)
#  - Installs requirements.txt for tensorflow/models
#  - TF 2.0 tested with cuda 10.0, but we need to test tf 2.1 with cuda 10.1.

FROM nvidia/cuda:10.1-base-ubuntu18.04 as base
ARG tensorflow_pip_spec="tf-nightly-gpu"
ARG local_tensorflow_pip_spec=""
ARG extra_pip_specs=""

# setup.py passes the base path of local .whl file is chosen for the docker image.
# Otherwise passes an empty existing file from the context.
COPY ${local_tensorflow_pip_spec} /${local_tensorflow_pip_spec}

# Pick up some TF dependencies
# cublas-dev and libcudnn7-dev only needed because of libnvinfer-dev which may not
# really be needed.
# In the future, add the following lines in a shell script running on the
# benchmark vm to get the available dependent versions when updating cuda
# version (e.g to 10.2 or something later):
# sudo apt-cache search cuda-command-line-tool
# sudo apt-cache search cuda-cublas
# sudo apt-cache search cuda-cufft
# sudo apt-cache search cuda-curand
# sudo apt-cache search cuda-cusolver
# sudo apt-cache search cuda-cusparse

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cuda-command-line-tools-10-1 \
        cuda-cufft-10-1 \
        cuda-curand-10-1 \
        cuda-cusolver-10-1 \
        cuda-cusparse-10-1 \
        libcudnn7=7.6.4.38-1+cuda10.1  \
        libcudnn7-dev=7.6.4.38-1+cuda10.1  \
        libfreetype6-dev \
        libhdf5-serial-dev \
        libzmq3-dev \
        libpng-dev \
        pkg-config \
        software-properties-common \
        unzip \
        lsb-core \
        curl && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && \
    apt-get install -y --no-install-recommends libnvinfer5=5.1.5-1+cuda10.1 \
    libnvinfer-dev=5.1.5-1+cuda10.1 \
    libnvinfer6=6.0.1-1+cuda10.1 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

# For CUDA profiling, TensorFlow requires CUPTI.
ENV LD_LIBRARY_PATH /usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH

# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8

# Add google-cloud-sdk to the source list
RUN echo "deb http://packages.cloud.google.com/apt cloud-sdk-$(lsb_release -c -s) main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# Install extras needed by most models
RUN apt-get update && apt-get install -y --no-install-recommends \
      git \
      ca-certificates \
      wget \
      htop \
      zip \
      google-cloud-sdk && rm -rf /var/lib/apt/lists/*;

# Install / update Python and Python3
RUN apt-get install -y --no-install-recommends \
      python3 \
      python3-dev \
      python3-pip \
      python3-setuptools \
      python3-venv && rm -rf /var/lib/apt/lists/*;

# Upgrade pip, need to use pip3 and then pip after this or an error
# is thrown for no main found.
RUN pip3 install --no-cache-dir --upgrade pip
# setuptools upgraded to fix install requirements from model garden.
RUN pip install --no-cache-dir wheel
RUN pip install --no-cache-dir --upgrade setuptools google-api-python-client==1.8.0 pyyaml google-cloud google-cloud-bigquery mock
RUN pip install --no-cache-dir absl-py
RUN pip install --no-cache-dir --upgrade --force-reinstall ${tensorflow_pip_spec} ${extra_pip_specs}
RUN pip install --no-cache-dir tfds-nightly
RUN pip install --no-cache-dir -U scikit-learn

RUN curl -f https://raw.githubusercontent.com/tensorflow/models/master/official/requirements.txt > /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

RUN pip freeze
