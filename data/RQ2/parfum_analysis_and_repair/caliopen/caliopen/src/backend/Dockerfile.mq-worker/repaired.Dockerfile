# This file creates a container that runs a Caliopen message handler
# Important:
# Author: Caliopen
# Date: 2018-07-20

FROM public-registry.caliopen.org/caliopen_python
MAINTAINER Caliopen

RUN apk -U upgrade

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
RUN pip install --no-cache-dir tornado==4.2
RUN pip install --no-cache-dir nats-client >=0.8.4

# Install python backend packages in develop mode
WORKDIR /srv/caliopen/src/backend/interfaces/NATS/py.client
RUN pip install --no-cache-dir -e .

WORKDIR /srv/caliopen/src/backend/interfaces/NATS/py.client/caliopen_nats
CMD ["python", "listener.py", "-f", "/etc/caliopen/caliopen.yaml"]
