FROM gcr.io/google.com/cloudsdktool/cloud-sdk
# gcr.io/cloud-builders/gcloud

RUN set -ex && apt-get update && apt-get -y --no-install-recommends install make \
    && apt-get -y --no-install-recommends install gettext-base \
    && python3 --version \
    && pip3 install --no-cache-dir --upgrade pip \
    && pip3 --version \
    && pip3 install --no-cache-dir setuptools \
    && git clone https://github.com/GoogleCloudPlatform/cloud-foundation-toolkit \
    && cd cloud-foundation-toolkit/dm \
    && rm -rf templates \
    && pip3 install --no-cache-dir tox \
    && pip3 install --no-cache-dir pytest wheel \
    && make build \
    && make install \
    && make cft-venv \
    && make template-prerequisites \
    && make cft-prerequisites \
    && . venv/bin/activate \
    && ./src/cftenv \
    && pwd \
    && cft --version \
    && bats -v \
    && which bats && rm -rf /var/lib/apt/lists/*;

WORKDIR /cloud-foundation-toolkit/dm
