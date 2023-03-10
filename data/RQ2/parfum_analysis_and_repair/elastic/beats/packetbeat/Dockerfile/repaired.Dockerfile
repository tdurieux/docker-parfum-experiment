FROM golang:1.17.11

RUN \
    apt-get update \
      && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
         python3 \
         python3-pip \
         python3-venv \
         librpm-dev \
         netcat \
         libpcap-dev \
      && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --upgrade pip==20.1.1
RUN pip3 install --no-cache-dir --upgrade setuptools==47.3.2
RUN pip3 install --no-cache-dir --upgrade docker-compose==1.23.2
