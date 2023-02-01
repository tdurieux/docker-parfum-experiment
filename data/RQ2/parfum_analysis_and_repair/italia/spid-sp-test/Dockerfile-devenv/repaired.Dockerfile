FROM python:3.8-slim-buster

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        xmlsec1 \
        libxml2-dev \
        libxmlsec1-dev \
        libxmlsec1-openssl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

COPY . /tmp/src/
RUN pip install --no-cache-dir /tmp/src/ 
RUN pip install --no-cache-dir -r /tmp/src/requirements-dev.txt

WORKDIR /tmp/src/

CMD cd /tmp/src && ls -la && pytest --cov=spid_sp_test tests/test_*