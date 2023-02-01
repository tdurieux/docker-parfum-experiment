# Dockerfile for the backend of Gazetteer

FROM ubuntu:12.04
MAINTAINER Han Xu <han@hxu.io>

# Basic packages
RUN apt-get update && apt-get -y --no-install-recommends install build-essential python-dev python-setuptools python-virtualenv python-pip vim tmux htop git libffi-dev libxml2-dev libxslt1-dev curl python-software-properties software-properties-common && rm -rf /var/lib/apt/lists/*;

# Project requirements file
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Program files and data files
COPY backend /srv/hk_census_explorer/backend

WORKDIR /srv/hk_census_explorer/backend
EXPOSE 8080
ENTRYPOINT ["uwsgi"]
CMD ["uwsgi.ini"]
