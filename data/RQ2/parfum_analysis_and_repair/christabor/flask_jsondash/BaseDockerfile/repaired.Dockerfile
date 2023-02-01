FROM python:2.7-slim
MAINTAINER Chris Tabor "dxdstudio@gmail.com"

RUN apt-get update -y && apt-get install -y --no-install-recommends python-pip python-dev build-essential --assume-yes && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir gunicorn

COPY . /app
WORKDIR /app

RUN pip install --no-cache-dir -e .
