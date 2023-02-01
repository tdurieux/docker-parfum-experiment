FROM python:3.8

COPY . /opt/binlex/

WORKDIR /opt/binlex/

RUN apt-get -qq -y update && \
    apt-get install --no-install-recommends -qq -y build-essential make cmake git libtlsh-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -v .
