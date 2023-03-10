FROM ubuntu:16.04

LABEL maintainer="Shanqing Cai <cais@google.com>"

RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
    libcurl4-openssl-dev \
    python \
    python-pip && rm -rf /var/lib/apt/lists/*;

# Install Google Cloud SDK
RUN curl -f -O https://dl.google.com/dl/cloudsdk/channels/rapid/install_google_cloud_sdk.bash
RUN chmod +x install_google_cloud_sdk.bash
RUN ./install_google_cloud_sdk.bash --disable-prompts --install-dir=/var/gcloud

# Install TensorFlow pip from build context.
COPY tensorflow-*.whl /
RUN pip install --no-cache-dir /tensorflow-*.whl

# Copy test files
RUN mkdir -p /gcs-smoke/python
COPY gcs_smoke_wrapper.sh /gcs-smoke/
COPY python/gcs_smoke.py /gcs-smoke/python/
