FROM python:3.8-slim

LABEL title "Assorted Python 3 code"
LABEL maintainer "Diego / Kartones"
LABEL url "https://kartones.net"
LABEL twitter "@kartones"

# Define environment vars to expose to container here
# ENV <key> <value>

# Env vars sent from docker-compose or docker build
ARG uid=1000
ARG gid=1000

RUN getent group $gid || groupadd --gid $gid python-assorted
RUN getent passwd $uid || useradd -m -u $uid -g $gid python-assorted

RUN chown -R $uid:$gid /usr/local

USER $uid

COPY requirements.txt /code/requirements.txt
RUN pip install --no-cache-dir -r /code/requirements.txt
