FROM girder/girder_worker:latest-py3
MAINTAINER Christopher Kotfila <chris.kotfila@kitware.com>

USER root

# Remove the sdist install from the base image
RUN pip uninstall -y girder-worker

RUN apt-get update && apt-get install -y sudo

RUN apt-get install -y git

RUN pip3 install docker

VOLUME /girder_worker

# Make sure remote debugging is available
RUN pip3 install rpdb
# Make sure we have the newest girder_client (on 2.x-maintenance)
RUN pip install -U "git+https://github.com/girder/girder.git@2.x-maintenance#egg=girder_client&subdirectory=clients/python"

COPY ./scripts /scripts
ENV PYTHON_BIN=python3
ENV PIP_BIN=pip3

ENTRYPOINT ["/scripts/wait-for-it.sh", "rabbit:5672", "--", "/scripts/gw_entrypoint.sh"]
