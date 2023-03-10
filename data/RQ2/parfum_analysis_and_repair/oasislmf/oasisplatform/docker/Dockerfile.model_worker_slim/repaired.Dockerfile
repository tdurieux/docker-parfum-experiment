# ---- STAGE 1 -----
FROM python:3.8.3-slim AS build-packages

RUN apt-get update && apt-get install --no-install-recommends -y libgeos-dev libspatialindex-dev git curl g++ build-essential libtool zlib1g-dev autoconf automake && rm -rf /var/lib/apt/lists/*;
COPY ./requirements-worker.txt ./requirements.txt
RUN pip install --no-cache-dir --user --no-warn-script-location -r ./requirements.txt


# ---- STAGE 2 ---- DEBIAN
FROM python:3.8.3-slim
RUN apt-get update && apt-get install -y --no-install-recommends libspatialindex-dev curl procps && \ 
    rm -rf /var/lib/apt/lists/*



COPY --from=build-packages /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH

ENV OASIS_MEDIA_ROOT=/shared-fs
ENV OASIS_ENV_OVERRIDE=true
RUN adduser --shell /bin/bash --disabled-password --gecos "" worker
WORKDIR /home/worker

COPY ./src/startup_worker.sh ./startup.sh
COPY ./src/startup_tester.sh ./runtest
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
    mkdir -p /home/worker/model && \
    mkdir -p /var/log/oasis && \
    touch /var/log/oasis/worker.log && \
    chmod 777 /var/log/oasis/worker.log

RUN chmod -R 777 /home/worker /var/log/oasis /var/oasis && \
    chown -R worker /home/worker && \
    chown -R worker /var/oasis && \
	chown -R worker /var/log

ENTRYPOINT ./startup.sh
