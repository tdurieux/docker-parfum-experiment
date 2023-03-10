# Setup container to publish synthetic-monitoring-agent packages to GCS
#
# Usage to run the container:
# 1. Set GPG environment variables:
#    - GPG_PRIV_KEY="base64 encoded private key"
#    - GPG_KEY_PASSWORD="base64 encoded passphrase"
# 2. Mount a volume to '/keys' containing a gcs-key.json credentials file
#    for a service account that can write to GCS buckets. This can be
#    pulled from vault at secret/data/synthetic-monitoring/gcp-sm-publish-grafanalabs-global
#
FROM cimg/go:1.17
USER root

# Setup required packages
RUN apt-get update && \
    apt-get install --no-install-recommends -y gnupg2 && \
    apt-get install --no-install-recommends -y rpm && \
    apt-get install --no-install-recommends -y ruby ruby-dev rubygems build-essential && \
    gem install --no-document fpm && rm -rf /var/lib/apt/lists/*;

# Install newest version of aptly. If fails retrieving key, retry the build.
RUN apt-key adv --keyserver pool.sks-keyservers.net --recv-keys ED75B5A4483DA07C
RUN wget -qO - https://www.aptly.info/pubkey.txt | apt-key add -
RUN add-apt-repository "deb http://repo.aptly.info/ squeeze main"
RUN apt-get update && \
    apt-get install -y --no-install-recommends aptly && rm -rf /var/lib/apt/lists/*;

# Download gcloud package
RUN curl -f https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz

# Install the gcloud package
RUN mkdir -p /usr/local/gcloud && \
    tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz && \
    /usr/local/gcloud/google-cloud-sdk/install.sh && rm /tmp/google-cloud-sdk.tar.gz

# Add gcloud to the path
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

RUN mkdir /synthetic-monitoring

WORKDIR /synthetic-monitoring
