#+++++++++++++++++++++++++++++++++++++++
# Dockerfile for webdevops/ansible:ubuntu-15.10
#    -- automatically generated  --
#+++++++++++++++++++++++++++++++++++++++

FROM webdevops/bootstrap:ubuntu-15.10

RUN set -x \
    # Install ansible
    && apt-install \
        python-minimal \
        python-setuptools \
        python-pip \
        python-paramiko \
        python-jinja2 \
        python-dev \
        libffi-dev \
        libssl-dev \
        build-essential \
        openssh-client \
    && pip install --no-cache-dir --upgrade pip \
    && hash -r \
    && pip install --no-cache-dir ansible \
    && chmod 750 /usr/local/bin/ansible* \
    # Cleanup
    && apt-get purge -y -f --force-yes \
        python-dev \
        build-essential \
        libssl-dev \
        libffi-dev \
    && docker-run-bootstrap \
    && docker-image-cleanup
