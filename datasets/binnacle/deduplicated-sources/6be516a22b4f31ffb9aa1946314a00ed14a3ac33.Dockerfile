# This file creates a container that runs a Caliopen message handler
# Important:
# Author: Caliopen
# Date: 2018-07-20

FROM public-registry.caliopen.org/caliopen_python
MAINTAINER Caliopen

# Add local backend source directory in container filesystem
COPY . /srv/caliopen/src/backend

# Install Caliopen base packages
WORKDIR /srv/caliopen/src/backend/main/py.storage
RUN pip install -e .
WORKDIR /srv/caliopen/src/backend/components/py.pgp
RUN pip install -e .
WORKDIR /srv/caliopen/src/backend/components/py.pi
RUN pip install -e .
WORKDIR /srv/caliopen/src/backend/main/py.main
RUN pip install -e .

## Container specific installation part
RUN pip install tornado==4.2
RUN pip install nats-client

# Install python backend packages in develop mode
WORKDIR /srv/caliopen/src/backend/interfaces/NATS/py.client
RUN pip install -e .

WORKDIR /srv/caliopen/src/backend/interfaces/NATS/py.client/caliopen_nats
CMD ["python", "listener.py", "-f", "/etc/caliopen/caliopen.yaml"]
