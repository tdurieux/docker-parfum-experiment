FROM ubuntu:16.04

MAINTAINER Shanqing Cai <cais@google.com>

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    libcurl4-openssl-dev \
    python \
    python-numpy \
    python-pip && rm -rf /var/lib/apt/lists/*;

# Install Google Cloud SDK
RUN curl -f -O https://dl.google.com/dl/cloudsdk/channels/rapid/install_google_cloud_sdk.bash
RUN chmod +x install_google_cloud_sdk.bash
RUN ./install_google_cloud_sdk.bash --disable-prompts --install-dir=/var/gcloud

# Install nightly TensorFlow pip
RUN pip install --no-cache-dir \
   https://ci.tensorflow.org/view/Nightly/job/nightly-matrix-cpu/TF_BUILD_IS_OPT=OPT,TF_BUILD_IS_PIP=PIP,TF_BUILD_PYTHON_VERSION=PYTHON2,label=cpu-slave/lastSuccessfulBuild/artifact/pip_test/whl/tensorflow-0.12.1-rc0-0rc-0rc-cp27-none-linux_x86_64.whl

# Copy test files
RUN mkdir -p /gcs-smoke/python
COPY gcs_smoke_wrapper.sh /gcs-smoke/
COPY python/gcs_smoke.py /gcs-smoke/python/
