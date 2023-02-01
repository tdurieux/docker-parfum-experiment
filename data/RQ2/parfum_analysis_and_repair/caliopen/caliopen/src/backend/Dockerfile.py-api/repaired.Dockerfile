# This file creates a container that runs a Caliopen v1 API (python based)
# Important:
# Author: Caliopen
# Date: 2018-07-20

FROM public-registry.caliopen.org/caliopen_python
MAINTAINER Caliopen

RUN apk -U upgrade

RUN apk add --no-cache nginx linux-headers supervisor
RUN pip install --no-cache-dir gunicorn paste

# Copy configuration files to run apiv1 behind uwsi and nginx
COPY ./configs/apiv1-nginx.conf /etc/nginx/nginx.conf
COPY ./configs/apiv1-supervisord.conf /etc/supervisor.d/apiv1.ini

# Add local backend source directory in container filesystem
COPY . /srv/caliopen/src/backend

# Install Caliopen base packages
WORKDIR /srv/caliopen/src/backend/main/py.storage
RUN pip install --no-cache-dir -e .
WORKDIR /srv/caliopen/src/backend/components/py.pgp
RUN pip install --no-cache-dir -e .
WORKDIR /srv/caliopen/src/backend/components/py.pi
RUN pip install --no-cache-dir -e .
WORKDIR /srv/caliopen/src/backend/main/py.main
RUN pip install --no-cache-dir -e .

## Container specific installation part

# Install python API packages
WORKDIR /srv/caliopen/src/backend/interfaces/REST/py.server
RUN pip install --no-cache-dir -e .

# Add documentation in container filesystem
WORKDIR /srv/caliopen/src/backend/tools/py.doc
RUN pip install --no-cache-dir -e .

EXPOSE 6543

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
