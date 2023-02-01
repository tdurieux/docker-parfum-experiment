FROM python:3.6.5-alpine

RUN apk update && apk add --no-cache netcat-openbsd && apk add --no-cache g++ gcc libxslt-dev

# set working directory
WORKDIR /srv

# add and install requirements
COPY requirements.txt /srv/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt --proxy=${HTTP_PROXY}

# add app
COPY . /srv
