FROM gcr.io/cloud-builders/gcloud-slim

RUN apt-get update \
    && apt-get install --no-install-recommends -y gcc python3-dev python3-setuptools python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install --no-cache-dir -U crcmod

COPY checksum /bin
COPY save_cache /bin
COPY restore_cache /bin

RUN chmod +x /bin/checksum /bin/save_cache /bin/restore_cache