FROM tiangolo/uwsgi-nginx-flask:python3.7
# maybe we want to move to:
# FROM tiangolo/meinheld-gunicorn-flask:python3.6

LABEL maintainer="Akshay Dahiya <xadahiya@gmail.com>"

COPY ./requirements.txt requirements.txt
# install certificates which were not installed in the base image
RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -U pip && pip install --no-cache-dir --upgrade pip setuptools \
      && pip install --no-cache-dir -r requirements.txt && rm -rf *

COPY  . /app

ENV PYTHONPATH $PYTHONPATH:/app:/app/hydrus

RUN mv /app/hydrus/uwsgi.ini /app/uwsgi.ini

ENV MESSAGE "Hail Hydra"
