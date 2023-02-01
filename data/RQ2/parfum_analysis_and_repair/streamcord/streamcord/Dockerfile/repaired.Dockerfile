FROM python:3.8

ADD . /app
WORKDIR /app

RUN pip3 install --no-cache-dir -r requirements.txt -U
