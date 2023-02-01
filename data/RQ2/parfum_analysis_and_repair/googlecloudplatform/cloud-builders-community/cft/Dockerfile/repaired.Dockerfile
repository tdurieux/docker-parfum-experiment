FROM gcr.io/cloud-builders/gcloud

RUN apt-get update && apt-get -y --no-install-recommends install make \
    && pip install --no-cache-dir setuptools \
    && git clone https://github.com/GoogleCloudPlatform/cloud-foundation-toolkit \
    && cd cloud-foundation-toolkit/ \
    && cd dm \
    && make cft-prerequisites \
    && make build \
    && make install \
    && cd / \
    && rm -rf /cloud-foundation-toolkit && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/usr/local/bin/cft"]
