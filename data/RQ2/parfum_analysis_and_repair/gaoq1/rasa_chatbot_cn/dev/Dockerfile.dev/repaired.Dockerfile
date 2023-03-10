FROM python:3.6-slim

SHELL ["/bin/bash", "-c"]

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

RUN apt-get update -qq && \
  apt-get install -y --no-install-recommends \
  apt-utils \
  vim \
  procps \
  build-essential \
  wget \
  unzip \
  openssh-client \
  graphviz-dev \
  pkg-config \
  git-core \
  openssl \
  libssl-dev \
  libffi6 \
  libffi-dev \
  libpng-dev \
  curl \
  python3-tk \
  tk-dev && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  mkdir /app

WORKDIR /app

ENV PYTHONPATH "${PYTHONPATH}:/app"

COPY requirements.txt ./

RUN pip install --no-cache-dir --upgrade pip -i https://mirrors.aliyun.com/pypi/simple/ && \
  pip install --no-cache-dir -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple/

ENTRYPOINT ["/bin/sh"]
CMD ["/app/dev/run.sh"]
