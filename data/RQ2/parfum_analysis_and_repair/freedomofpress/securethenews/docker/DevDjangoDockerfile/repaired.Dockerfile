# sha256 as of 2021-07-22
FROM python:3.9-slim-buster@sha256:4e69709296a8ae67d97ba072e7f4973125939f3a13cd276c1e8ca1f7b7d49aa3

RUN apt-get update && \
        apt-get install --no-install-recommends -y \
        bash \
        build-essential \
        curl \
        gcc \
        git \
        libjpeg-dev \
        libffi-dev \
        libpq-dev \
        libtiff-dev \
        libssl-dev \
        libz-dev \
        musl-dev \
        netcat-traditional \
        paxctl \
        python3-dev && rm -rf /var/lib/apt/lists/*;

COPY docker/django-start.sh /usr/local/bin
RUN  chmod +x /usr/local/bin/django-start.sh

# docker-compose must pass in the host UID here so that the volume
# permissions are correct
ARG USERID
RUN adduser --disabled-password --gecos "" --uid "${USERID?USERID must be supplied}" gcorn

RUN paxctl -cm /usr/local/bin/python
COPY securethenews/dev-requirements.txt /requirements.txt
RUN pip install --no-cache-dir --require-hashes -r /requirements.txt

RUN  mkdir /deploy && \
    chown -R gcorn: /deploy

EXPOSE 8000
USER gcorn

CMD ["/usr/local/bin/django-start.sh"]
