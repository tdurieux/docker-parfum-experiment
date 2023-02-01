FROM ubuntu:trusty

RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential libffi-dev \
    libssl-dev python-dev python-minimal python-pip python-setuptools \
    python-virtualenv && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip setuptools && pip install --no-cache-dir ansible
