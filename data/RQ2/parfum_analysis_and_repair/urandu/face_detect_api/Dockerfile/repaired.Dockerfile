FROM python:3.7
ENV LANG C.UTF-8

MAINTAINER bildad namawa "bildadnamawa@gmail.com"

RUN mkdir /django

COPY . /django

RUN apt-get -y update
RUN apt-get install --no-install-recommends -y python python3-pip python-dev && rm -rf /var/lib/apt/lists/*;

ADD requirements.txt /django/requirements.txt
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r /django/requirements.txt
RUN apt-get -y update && apt-get -y autoremove

WORKDIR /django

EXPOSE 8000

CMD gunicorn -b :8000 django.wsgi
