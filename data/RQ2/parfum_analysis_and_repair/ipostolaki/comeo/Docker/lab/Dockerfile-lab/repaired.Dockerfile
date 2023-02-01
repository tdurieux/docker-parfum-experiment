FROM python:3.5
ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get -y --no-install-recommends install netcat && rm -rf /var/lib/apt/lists/*;

# these instructions with pip installs will be cached, so they will not be executed on image rebuild

# Base dependencies
RUN pip install --no-cache-dir django==1.9.7
RUN pip install --no-cache-dir psycopg2==2.6.1
RUN pip install --no-cache-dir celery==3.1.23
RUN pip install --no-cache-dir django-bootstrap-form==3.2.1
RUN pip install --no-cache-dir django-ckeditor==4.5.1
RUN pip install --no-cache-dir Pillow==3.2.0

# Registry app dependencies
RUN pip install --no-cache-dir neomodel==2.0.2

# Lab(prod) only dependencies
RUN pip install --no-cache-dir django-smtp-ssl==1.0
RUN pip install --no-cache-dir gunicorn==19.6.0
