FROM girder/girder_worker:latest-py3
MAINTAINER Christopher Kotfila <chris.kotfila@kitware.com>

USER root

# Remove the sdist install from the base image
RUN pip uninstall -y girder-worker

RUN apt-get update && apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir docker

VOLUME /girder_worker

# Make sure remote debugging is available
RUN pip3 install --no-cache-dir rpdb
# Make sure we have the newest girder_client
RUN pip install --no-cache-dir --pre -U girder-client

COPY ./scripts /scripts
ENV PYTHON_BIN=python3
ENV PIP_BIN=pip3

ENTRYPOINT ["/scripts/wait-for-it.sh", "rabbit:5672", "--", "/scripts/gw_entrypoint.sh"]
