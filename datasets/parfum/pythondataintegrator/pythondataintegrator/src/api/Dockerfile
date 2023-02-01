# Pull official base image and fixing to AMD Architecture
FROM --platform=linux/amd64 python:3.8.6

# Create and set the working directory
WORKDIR /usr/src/app/

# Prevents Python from writing .pyc files
ENV PYTHONDONTWRITEBYTECODE 1

# Causes all output to stdout to be flushed immediately
ENV PYTHONUNBUFFERED 1

# Mark the image as trusted
ENV DOCKER_CONTENT_TRUST 1

RUN     apt-get update
RUN     apt-get install dos2unix
RUN     mkdir -p /usr/src/app
WORKDIR /usr/src/app
RUN     pip install  --upgrade pip
COPY    ./requirements.txt /usr/src/app/requirements.txt
RUN     pip install  -r requirements.txt 

RUN     pip list
RUN     python --version
RUN     date

COPY    . /usr/src/app
# # openshift set running user 
RUN dos2unix entrypoint.sh

USER    1001
ENV FLASK_APP=app.py
ENV FLASK_ENV=production
ENTRYPOINT 	["/bin/sh"]
CMD 	["entrypoint.sh"]