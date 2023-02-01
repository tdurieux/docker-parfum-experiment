FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y --no-install-recommends install \
    build-essential \
    git \
    mysql-server \
    libmysqlclient-dev \
    python-pip \
    python-dev \
    python-virtualenv \
    python3-pip \
    python3-tk \
    python3.7 \
    python3.7-dev && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --upgrade pip

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

COPY example/requirements.txt ./example/
RUN pip3 install --no-cache-dir -r example/requirements.txt