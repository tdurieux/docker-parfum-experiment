FROM python:3.6

ENV OASIS_MEDIA_ROOT=/shared-fs

RUN apt-get update && apt-get install -y --no-install-recommends git vim libspatialindex-dev && rm -rf /var/lib/apt/lists/*

RUN adduser --shell /bin/bash --disabled-password --gecos "" worker
WORKDIR /home/worker

# Install requirements
COPY ./requirements.txt /tmp/
RUN pip install -r /tmp/requirements.txt

# Copy startup script + server config
COPY ./src/startup_worker.sh ./startup.sh
COPY ./src/startup_tester.sh ./runtest
COPY ./conf.ini ./

COPY ./src/__init__.py ./src/
COPY ./src/common ./src/common/
COPY ./src/conf ./src/conf/
COPY ./src/model_execution_worker/ ./src/model_execution_worker/
COPY ./src/utils/ ./src/utils/
COPY ./tests /home/worker/tests

RUN mkdir -p /var/oasis/working && \
    mkdir -p /var/log/oasis && \
    touch /var/log/oasis/worker.log && \
    chmod 777 /var/log/oasis/worker.log

RUN chmod -R 777 /home/worker /var/log/oasis /var/oasis && \
    chown -R worker /home/worker && \
    chown -R worker /var/oasis && \
	chown -R worker /var/log && \
    chown -R worker /var/oasis/working

ENTRYPOINT ./startup.sh
