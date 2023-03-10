# development dockerfile
# a volume with the api code must be mounted
# in the /backend path via docker or docker-compose
# the file /backend/main.py is expected as the flask
# starting point
#
# This is a simple flask devserver docker image. there is no nginx or
# uwsgi setup, during development the frontend must be served from the 
# vite devserver

FROM python:3.9-buster

ADD wait.sh /wait.sh
RUN chmod +x /wait.sh

COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

WORKDIR /backend

ENV FLASK_APP=main.py
ENV FLASK_ENV=development
ENV FLASK_DEBUG=1

#initialize the flask dev server