FROM python:3.8

ENV OASIS_MEDIA_ROOT=/shared-fs
ENV OASIS_ENV_OVERRIDE=true

RUN apt-get update && apt-get install -y --no-install-recommends git vim libspatialindex-dev && rm -rf /var/lib/apt/lists/*

RUN adduser --shell /bin/bash --disabled-password --gecos "" worker
WORKDIR /home/worker

# Install requirements
COPY ./requirements-worker.txt ./requirements.txt
RUN pip install --no-cache-dir -r ./requirements.txt

# Copy startup script + server config
COPY ./src/startup_worker.sh ./startup.sh
COPY ./src/startup_tester.sh ./runtest
COPY ./src/startup_tester_S3.sh ./runtest_S3
COPY ./conf.ini ./

COPY ./src/__init__.py ./src/
COPY ./src/common ./src/common/
COPY ./src/conf ./src/conf/
COPY ./src/model_execution_worker/ ./src/model_execution_worker/
COPY ./src/utils/ ./src/utils/
COPY ./src/utils/worker_bashrc /root/.bashrc
COPY ./tests/integration /home/worker/tests/integration
COPY ./VERSION ./

RUN mkdir -p /var/oasis && \
    mkdir -p /var/log/oasis && \
    touch /var/log/oasis/worker.log && \
    chmod 777 /var/log/oasis/worker.log

RUN chmod -R 777 /home/worker /var/log/oasis /var/oasis && \
    chown -R worker /home/worker && \
    chown -R worker /var/oasis && \
	chown -R worker /var/log

ENTRYPOINT ./startup.sh
