from python:3.7
MAINTAINER cb-developer-network@vmware.com

COPY . /app
WORKDIR /app

RUN pip3 install --no-cache-dir -r requirements.txt
