FROM python:3.8-slim-buster

WORKDIR /workarea

COPY requirements.txt requirements.txt
COPY . .

RUN pip3 install --no-cache-dir -r requirements.txt