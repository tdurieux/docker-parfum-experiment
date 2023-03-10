ARG UBUNTU_VERSION=16.04
FROM ubuntu:${UBUNTU_VERSION}

ARG USE_PYTHON_3_NOT_2=True
ARG _PY_SUFFIX=${USE_PYTHON_3_NOT_2:+3}
ARG PYTHON=python${_PY_SUFFIX}
ARG PIP=pip${_PY_SUFFIX}

RUN apt-get update && apt-get install --no-install-recommends -y \
    ${PYTHON} \
    ${PYTHON}-pip && rm -rf /var/lib/apt/lists/*;

RUN ${PIP} install --upgrade \
    pip \
    setuptools

RUN pip install --no-cache-dir jupyter jupyterlab

WORKDIR /app
ADD . /app


RUN ${PIP} install --trusted-host pypi.python.org -r cpu_requirements.txt
