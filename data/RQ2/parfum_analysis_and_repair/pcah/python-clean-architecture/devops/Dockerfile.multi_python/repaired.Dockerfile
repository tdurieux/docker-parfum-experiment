# DEPRECIATED
# this Dockerfile is left as a depreciated backward-compatibility feature

FROM ubuntu:focal as dev
ARG DOCKER_MULTI_PYTHON_SCRIPT_URL=https://raw.githubusercontent.com/fkrull/docker-multi-python/2fb60d333f3e407fea4ceb4293b414cc435ff084/setup.sh
ENV DEBIAN_FRONTEND=noninteractive \
    PATH="${PATH}:/root/.poetry/bin" \
    PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    POETRY_VERSION=1.1.4 \
    PYTHONFAULTHANDLER=1 \
    PYTHONHASHSEED=random \
    PYTHONUNBUFFERED=1 \
    WORKSPACE="/workspace"
WORKDIR ${WORKSPACE}
RUN apt update -y \
    && apt install -y --no-install-recommends \
    ca-certificates \
    curl \
    pypy3 \
    python3-dev \
    tree \
    vim \
    && curl -f -sSL $DOCKER_MULTI_PYTHON_SCRIPT_URL | bash \
    && rm -rf /var/lib/apt/lists/* \
    && dpkg-query --show pypy3 >> /versions
RUN pip3 install --no-cache-dir -U \
    pip \
    poetry==${POETRY_VERSION} \
    setuptools \
    tox \
    && mkdir -p /root/.cache/pypoetry/virtualenvs/
COPY pyproject.toml poetry.lock ./
RUN poetry install --no-root --no-interaction
CMD [ "/bin/bash" ]

FROM dev AS test
CMD [ "poetry", "run", "tox" ]
