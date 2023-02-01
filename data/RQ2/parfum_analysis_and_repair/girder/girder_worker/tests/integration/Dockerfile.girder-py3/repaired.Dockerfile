FROM girder/girder:latest-py3
MAINTAINER Christopher Kotfila <chris.kotfila@kitware.com>

RUN pip3 install --no-cache-dir ansible girder-client

COPY ./scripts /scripts

# Allow mounting /girder_worker
RUN mkdir /girder_worker
VOLUME /girder_worker

# Make sure remote debugging is available
RUN pip3 install --no-cache-dir rpdb
# Make sure we have the newest girder_client
RUN pip install --no-cache-dir --pre -U girder-client

ENV PYTHON_BIN=python3
ENV PIP_BIN=pip3

ENTRYPOINT ["/scripts/girder_entrypoint.sh", "-H", "0.0.0.0", "-p", "8989", "-d", "mongodb://mongo:27017/girder"]
