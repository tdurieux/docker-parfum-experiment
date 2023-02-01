FROM python:3.9.9 as base

RUN apt-get update && apt-get install --no-install-recommends -y \
        jq \
        librdkafka-dev \
        python3-ldap \
        libldap2-dev \
        libsasl2-dev \
        libsasl2-modules \
        ldap-utils \
    && python -m pip install --upgrade pip wheel setuptools==57.5.0 && rm -rf /var/lib/apt/lists/*;

COPY ./base-requirements.txt requirements.txt

RUN pip install --no-cache-dir -r requirements.txt && \
    pip uninstall -y acryl-datahub