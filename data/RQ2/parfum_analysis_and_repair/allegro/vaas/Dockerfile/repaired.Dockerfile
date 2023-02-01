# pull official base image
FROM python:3.9.9-slim-buster


# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# create directory for the app
RUN mkdir -p /home/app
ENV HOME=/home/app

# set work directory
ENV APP_HOME=/home/app/vaas
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# create directory for the plugins
RUN mkdir $HOME/plugins
ENV PYTHONPATH=/home/app/plugins

VOLUME ["/home/app/plugins"]

RUN apt update \
    && apt install -y --no-install-recommends curl git default-libmysqlclient-dev build-essential default-mysql-client && rm -rf /var/lib/apt/lists/*;

# install dependencies
RUN pip install --no-cache-dir --upgrade pip

COPY ./vaas/requirements /home/app/vaas/requirements

RUN pip install --no-cache-dir -r ./requirements/base.txt

# copy project
COPY ./vaas /home/app/vaas

# copy entrypoints.sh
COPY \
  docker/entrypoint-uwsgi-dev.sh \
  docker/entrypoint-celery-worker.sh \
  docker/entrypoint-celery-routes-test.sh \
  docker/entrypoint-celery-scheduler.sh \
  docker/entrypoint-celery-cron-worker.sh \
  docker/wait-for-it.sh \
  /

# run entrypoint.sh
ENTRYPOINT ["/entrypoint-uwsgi-dev.sh"]