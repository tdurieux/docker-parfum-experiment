FROM ubuntu:18.04

MAINTAINER Graham Klyne <gk-annalist@ninebynine.org>

RUN apt-get update -y  && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y python python-pip python-virtualenv && \
    apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir annalist==0.5.18

VOLUME /annalist_site
ENV HOME=/annalist_site \
    OAUTHLIB_INSECURE_TRANSPORT=1

EXPOSE 8000

CMD annalist-manager runserver

