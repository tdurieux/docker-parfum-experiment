FROM ubuntu:14.04
MAINTAINER Andres Riancho <andres.riancho@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install --no-install-recommends -y supervisor joe && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libssl-dev libxml2-dev libxslt1-dev libmemcached-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git-core python-pip build-essential python-dev python-software-properties && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir supervisor-stdout==0.1.1

RUN mkdir -p /var/log/supervisor
RUN useradd ubuntu -d /home/ubuntu

# Django moth configuration
WORKDIR /home/ubuntu/

ADD . /home/ubuntu/django-moth
WORKDIR /home/ubuntu/django-moth
RUN pip install --no-cache-dir -r requirements.txt

RUN cp /home/ubuntu/django-moth/docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN rm -rf /var/lib/apt/lists/*

EXPOSE 8000
CMD ["/usr/bin/supervisord"]
