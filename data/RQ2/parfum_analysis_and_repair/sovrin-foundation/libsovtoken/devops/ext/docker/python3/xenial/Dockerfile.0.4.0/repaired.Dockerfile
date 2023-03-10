FROM sovrin/dockerbase:base-xenial-0.4.0
# TODO LABEL maintainer="Name <email-address>"

ARG PYTHON3_VERSION

ENV PYTHON3_VERSION=${PYTHON3_VERSION:-3.5}

# python
RUN apt-get update && apt-get install -y --no-install-recommends \
        python${PYTHON3_VERSION} \
        python3-pip \
        python-setuptools \
    && rm -rf /var/lib/apt/lists/*

# pypi based packages
RUN pip3 install --no-cache-dir -U \
        'pip<10.0.0' \
        setuptools \
        virtualenv

# TODO CMD ENTRYPOINT ...

ENV PYTHON3_ENV_VERSION=0.4.0
