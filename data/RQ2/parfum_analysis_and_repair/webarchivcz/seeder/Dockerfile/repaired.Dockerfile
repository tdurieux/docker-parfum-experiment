FROM python:3.7.3

RUN apt-get update && apt-get install --no-install-recommends -y \
    libjpeg-dev \
    libpq-dev \
    memcachedb \
    python3-dev \
    python-psycopg2 \
    git-core \
    python3-pip \
    gettext \
    cron \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ADD . /code
WORKDIR /code

RUN pip3 install --no-cache-dir -r requirements.txt --upgrade

ENV DJANGO_SETTINGS_MODULE=settings.env
RUN python3 /code/Seeder/manage.py collectstatic --noinput --clear
RUN unset DJANGO_SETTINGS_MODULE
EXPOSE 8000
