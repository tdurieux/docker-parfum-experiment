FROM python:3.7.6

RUN mkdir -p /github/workspace

WORKDIR /github/workspace

RUN pip3 install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir torch >=1.9.0 && \
    pip install --no-cache-dir gcastle
