FROM node:4-alpine

ENV PYTHONUNBUFFERED 1
RUN mkdir /code

WORKDIR /code

RUN apk add --no-cache \
        python-dev \
        py-pip \
        postgresql-dev \
        gcc \
        musl-dev \
        libffi-dev \
        openldap-dev \
        ca-certificates \
        bash \
        git

RUN npm install -g \
        --registry http://registry.npmjs.org/ \
        coffee-script \
        less@1.3

RUN pip install --upgrade pip wheel twine
# Gevent install is super slow...cache it early
RUN pip install gevent==1.2.1

ARG CABOT_VERSION
RUN git clone --branch=${CABOT_VERSION} https://github.com/arachnys/cabot /code

RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -r requirements-dev.txt
RUN pip install --no-cache-dir -r requirements-plugins.txt

RUN python manage.py collectstatic --noinput
RUN python manage.py compress
RUN python setup.py sdist bdist_wheel
RUN python setup.py install

ENTRYPOINT ["sh", "-c"]
