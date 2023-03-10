ARG IMAGE
FROM ${IMAGE}

SHELL ["/bin/bash", "-i", "-c"]

ARG PYTHON_VERSION=3.7.5

RUN echo "fastestmirror=true" >> /etc/dnf/dnf.conf

## Install System Dependencies
RUN dnf -y install \
    ruby-devel \
    gcc \
    make \
    rpm-build \
    libffi-devel \
    python-pip

## Install Arch Installer
RUN gem install --no-document fpm

## Install More Build Dependencies
RUN pip install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir fbs

ADD . home
COPY ./docker/installer/generator.sh generator.sh
ENTRYPOINT ["bash", "./generator.sh"]