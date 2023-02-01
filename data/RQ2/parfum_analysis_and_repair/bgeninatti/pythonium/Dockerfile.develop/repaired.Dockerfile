FROM python:3.9-slim

WORKDIR /usr/src/pythonium

ENV PYTHONUNBUFFERED 1

RUN pip install --no-cache-dir --upgrade pip
COPY . .
RUN python setup.py install
RUN pip install --no-cache-dir -r requirements.txt
