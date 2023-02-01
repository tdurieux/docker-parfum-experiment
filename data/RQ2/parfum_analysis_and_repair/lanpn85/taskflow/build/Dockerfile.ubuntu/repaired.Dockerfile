ARG BASE_IMAGE=ubuntu:18.04
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y \
    software-properties-common \
    binutils \
    make \
    build-essential \
    devscripts \
    debhelper-compat \
    dh-systemd && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository -y ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
        python3.7-dev \
        virtualenv && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /workspace/build
RUN chmod -R 777 /workspace
RUN virtualenv -p python3.7 /venv
ENV PATH="/venv/bin:$PATH"

WORKDIR /workspace/build
COPY ./requirements.txt /workspace/build/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
COPY ./requirements.dev.txt /workspace/build/requirements.dev.txt
RUN pip install --no-cache-dir -r requirements.dev.txt
