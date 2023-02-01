######################################
### Runbook.io - All Dockerfile ###
######################################


# Pull base image
FROM ubuntu:14.04

# OS Dependencies
RUN apt-get update --fix-missing && \
  apt-get upgrade -y && \
  apt-get install --no-install-recommends -y python \
  python-dev \
  python-pip \
  python-virtualenv \
  wget \
  unzip \
  build-essential \
  libssl-dev \
  libffi-dev && rm -rf /var/lib/apt/lists/*;

RUN rm -rf /var/lib/apt/lists/*


## Install Honcho
RUN pip install --no-cache-dir honcho

## Copy everything
COPY src /src

# Install python requirements
RUN pip install --no-cache-dir -r /src/web/requirements.txt
RUN pip install --no-cache-dir -r /src/monitors/requirements.txt
RUN pip install --no-cache-dir -r /src/actions/requirements.txt
RUN pip install --no-cache-dir -r /src/bridge/requirements.txt

RUN find /src/ -name "*.yml" | xargs -n 1 sed -i 's/actionbroker/127.0.0.1/g'
RUN find /src/ -name "*.yml" | xargs -n 1 sed -i 's/monitorbroker/127.0.0.1/g'

COPY Procfile /

CMD cd / && \
  python src/bridge/mgmtscripts/create_db.py src/bridge/config/config.yml && \
  honcho start

EXPOSE 8000
