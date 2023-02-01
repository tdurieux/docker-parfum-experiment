FROM python:3.6-alpine

ADD . /app
RUN cd /app && pip install --no-cache-dir -r requirements.txt
