FROM ubuntu:16.04

MAINTAINER Bruno Renié <bruno@renie.fr>

VOLUME /srv/graphite

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install --no-install-recommends -y language-pack-en && rm -rf /var/lib/apt/lists/*;
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales

RUN apt-get install --no-install-recommends -y build-essential python-dev libffi-dev libcairo2-dev python-pip && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir gunicorn graphite-api[sentry,cyanite]

ONBUILD ADD graphite-api.yaml /etc/graphite-api.yaml
ONBUILD RUN chmod 0644 /etc/graphite-api.yaml

EXPOSE 8000

CMD exec gunicorn -b 0.0.0.0:8000 -w 2 --log-level debug graphite_api.app:app
