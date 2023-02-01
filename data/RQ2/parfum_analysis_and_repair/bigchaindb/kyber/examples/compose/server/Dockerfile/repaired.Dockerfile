FROM python:3

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY setup.py /usr/src/app/
COPY server /usr/src/app/server

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -e .[dev]
