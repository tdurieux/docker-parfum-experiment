FROM ubuntu:bionic

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --fix-missing --no-install-recommends\
    libffi-dev libssl-dev build-essential libopenblas-dev\
    python3-pip python3-dev python3-venv python3-setuptools cmake\
    git iproute2 procps lsb-release \
    libsm6 libxext6 libxrender-dev \
    xvfb libgl1-mesa-glx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV ENV=/app
ENV PYTHON=$ENV/bin/python
ENV PIP=$ENV/bin/pip

RUN python3 -m pip install -U pip \
    && pip3 install virtualenv \
    && python3 -m venv $ENV \
    && $PYTHON -m pip install -U pip \
    && $PYTHON -m pip install -U poetry \
    && $PIP install setuptools>=41.0.0 \
    && $PIP install torch==1.6.0+cpu torchvision==0.7.0+cpu -f https://download.pytorch.org/whl/torch_stable.html \
    && rm -rf /root/.cache

WORKDIR /app

COPY requirements.txt .
RUN $PYTHON -m pip install -r requirements.txt && rm -rf /root/.cache