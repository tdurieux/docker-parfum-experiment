FROM python:3

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

RUN pip install --no-cache-dir --upgrade pip

COPY examples /usr/src/app/examples
COPY bigchaindb-server /usr/src/app/bigchaindb-server

WORKDIR /usr/src/app/bigchaindb-server

RUN pip install --no-cache-dir -e .[dev]

WORKDIR /usr/src/app/examples

RUN pip install --no-cache-dir -e .[dev]

