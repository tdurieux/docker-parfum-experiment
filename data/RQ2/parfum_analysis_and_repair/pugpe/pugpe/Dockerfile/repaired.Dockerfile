FROM python:2.7.7

ADD . /app
WORKDIR /app

RUN pip install --no-cache-dir -r requirements.txt
