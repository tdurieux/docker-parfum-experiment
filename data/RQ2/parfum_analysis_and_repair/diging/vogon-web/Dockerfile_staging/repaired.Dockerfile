FROM python:3

WORKDIR /usr/src/app

RUN mkdir run
RUN mkdir logs/
RUN mkdir bin
RUN mkdir data

RUN apt-get update && apt-get upgrade -y && apt-get autoremove && apt-get autoclean
# most of these are for lxml which needs a bunch of dependancies installed
RUN apt-get install --no-install-recommends -y \
    libffi-dev \
    libssl-dev \
    libxml2-dev \
    libxslt-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zlib1g-dev \
    net-tools \
    git-all \
    supervisor \
    vim \
    redis-server && rm -rf /var/lib/apt/lists/*;

COPY docker_scripts/vogon-gunicorn-staging.sh bin/vogon-gunicorn.sh
COPY docker_scripts/vogon-supervisord-staging.conf /etc/supervisor/conf.d/vogon-supervisord.conf
COPY docker_scripts/vogon-backend-startup-staging.sh bin/
RUN ["chmod", "+x", "/usr/src/app/bin/vogon-backend-startup-staging.sh"]
RUN ["chmod", "+x", "/usr/src/app/bin/vogon-gunicorn.sh"]

ENTRYPOINT ["./bin/vogon-backend-startup-staging.sh"]
