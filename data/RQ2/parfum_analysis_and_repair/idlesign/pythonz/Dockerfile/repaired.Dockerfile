FROM ubuntu:20.04

RUN apt-get update && \
    apt-get upgrade -y

RUN apt-get install --no-install-recommends -y python3-pip libpq-dev && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip

ARG DJANGO_SUPERUSER_USERNAME=admin
ARG DJANGO_SUPERUSER_PASSWORD=password
ARG DJANGO_SUPERUSER_EMAIL=admin@example.com

ADD . /app
WORKDIR /app

RUN pip3 install --no-cache-dir -r requirements.txt && \
    pip3 install --no-cache-dir -r tests/requirements.txt && \
    pip3 install --no-cache-dir -e .

RUN mkdir state

RUN pythonz migrate && \
    pythonz createsuperuser --noinput

