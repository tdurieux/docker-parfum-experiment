ARG PYTHON_VERSION=3.9
FROM python:${PYTHON_VERSION}-slim-buster

# Install apt-get packages
RUN apt-get update && \
    apt-get -y --no-install-recommends install \
    sudo \
    wget \
    zip \
    git \
    software-properties-common \
    gcc \
    g++ \
    clang-format \
    build-essential \
    python3-distutils \
    pkg-config \
    zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install libstdc++6 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y upgrade libstdc++6

RUN python3.9 -m pip install --upgrade pip

COPY ./ GreyNSights

WORKDIR GreyNSights

RUN pip install --no-cache-dir -r requirements.txt
RUN python3 setup.py install

ENTRYPOINT [ "/bin/bash" ]
