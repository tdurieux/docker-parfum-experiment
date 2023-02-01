FROM ubuntu:16.04

RUN mkdir -p /opt/project
WORKDIR /opt/project

# Prepare dependencies
RUN apt-get update && \
  apt-get install --no-install-recommends -y apt-transport-https ca-certificates unzip curl libcurl3 wget && rm -rf /var/lib/apt/lists/*;

# Install APT dependencies
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install python python-setuptools python-dev build-essential git && rm -rf /var/lib/apt/lists/*;

# Install google cloud
RUN curl -f -sSL https://sdk.cloud.google.com | bash && \
  /root/google-cloud-sdk/bin/gcloud config set --installation component_manager/disable_update_check true && \
  /root/google-cloud-sdk/bin/gcloud components install beta
ENV PATH $PATH:/root/google-cloud-sdk/bin

# Install python dependencies
RUN easy_install pip && \
    pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.2.0-cp27-none-linux_x86_64.whl && \
    pip install --no-cache-dir google-api-python-client pyyaml pytz newlinejson python-dateutil yattag pandas-gbq && \
    pip install --no-cache-dir git+https://github.com/GlobalFishingWatch/bqtools.git

COPY . /opt/project
RUN pip install --no-cache-dir .
