FROM python:3.5-slim-stretch

RUN apt-get update && apt-get install --no-install-recommends -y \
    libffi-dev \
    g++ \
    python3-dev \
    libmemcached-dev \
    libz-dev \
    memcached && rm -rf /var/lib/apt/lists/*;

COPY . /wikilabels
WORKDIR /wikilabels

RUN pip install --no-cache-dir pip --upgrade
RUN pip install --no-cache-dir wheel
RUN pip install --no-cache-dir -r /wikilabels/requirements.txt
RUN pip install --no-cache-dir -r /wikilabels/test-requirements.txt

ENTRYPOINT ./utility dev_server
EXPOSE 8080
