FROM php:7.4-cli

RUN apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
                        python-pip \
                        python-dev \
                        libffi-dev \
                        libssl-dev \
                        libxml2-dev \
                        libxslt1-dev \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir --upgrade markupsafe setuptools
RUN pip install --no-cache-dir --upgrade ansible
RUN ansible --version

WORKDIR /var/www/html