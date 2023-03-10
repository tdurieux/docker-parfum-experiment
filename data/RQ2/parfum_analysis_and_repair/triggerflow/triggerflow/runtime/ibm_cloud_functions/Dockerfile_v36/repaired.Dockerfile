# Based on: https://github.com/ibm-functions/runtime-python/tree/master/python3.6

FROM python:3.6-slim-buster

ENV FLASK_PROXY_PORT 8080

RUN apt-get update && apt-get install --no-install-recommends -y \
        gcc \
        libc-dev \
        libxslt-dev \
        libxml2-dev \
        libffi-dev \
        libssl-dev \
        git \
        zip \
        unzip \
        vim \
        && rm -rf /var/lib/apt/lists/*

RUN apt-cache search linux-headers-generic

COPY requirements.txt requirements.txt

RUN pip install --no-cache-dir --upgrade pip setuptools six && pip install --no-cache-dir -r requirements.txt

# Install Triggerflow lib
RUN git clone https://github.com/triggerflow/triggerflow && \
    cd triggerflow && python setup.py install

# create action working directory
RUN mkdir -p /action

RUN mkdir -p /actionProxy
COPY actionproxy.py /actionProxy/actionproxy.py

RUN mkdir -p /pythonAction
COPY pythonrunner.py /pythonAction/pythonrunner.py

CMD ["/bin/bash", "-c", "cd /pythonAction && python -u pythonrunner.py"]