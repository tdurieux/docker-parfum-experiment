ARG PARENT_IMAGE
FROM $PARENT_IMAGE
ARG USE_GPU

RUN apt-get -y update \
    && apt-get -y --no-install-recommends install \
    curl \
    cmake \
    default-jre \
    git \
    jq \
    python-dev \
    python-pip \
    python3-dev \
    libfontconfig1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    libopenmpi-dev \
    zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV CODE_DIR /root/code
ENV VENV /root/venv

COPY ./setup.py ${CODE_DIR}/stable-baselines/setup.py
RUN \
    pip install --no-cache-dir virtualenv && \
    virtualenv $VENV --python=python3 && \
    . $VENV/bin/activate && \
    pip install --no-cache-dir --upgrade pip && \
    cd ${CODE_DIR}/stable-baselines && \
    pip install --no-cache-dir -e .[mpi,tests] && \
    rm -rf $HOME/.cache/pip

ENV PATH=$VENV/bin:$PATH

# Codacy code coverage report: used for partial code coverage reporting
RUN cd $CODE_DIR && \
    curl -f -Ls -o codacy-coverage-reporter.jar "$( curl -f -Ls https://api.github.com/repos/codacy/codacy-coverage-reporter/releases/latest | jq -r '.assets | map({name, browser_download_url} | select(.name | (startswith("codacy-coverage-reporter") and contains("assembly") and endswith(".jar")))) | .[0].browser_download_url')"

CMD /bin/bash
