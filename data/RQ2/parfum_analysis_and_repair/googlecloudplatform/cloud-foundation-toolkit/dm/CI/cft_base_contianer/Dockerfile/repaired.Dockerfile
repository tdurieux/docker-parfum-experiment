FROM gcr.io/cloud-builders/gcloud



RUN set -ex && apt-get update && apt-get -y --no-install-recommends install make \
    && apt-get -y --no-install-recommends install gettext-base \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir setuptools \
    && git clone https://github.com/GoogleCloudPlatform/cloud-foundation-toolkit \
    && cd cloud-foundation-toolkit/dm \
    && rm -rf templates \
    && pip install --no-cache-dir tox \
    && pip install --no-cache-dir pytest wheel \
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
