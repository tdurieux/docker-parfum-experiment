# ---- STAGE 1 -----
FROM ubuntu:22.04 AS build-packages

# Build python packages
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y libspatialindex-dev git curl g++ build-essential libtool autoconf automake python3-dev python3 python3-pip pkg-config && rm -rf /var/lib/apt/lists/*;
COPY ./requirements-worker.txt ./requirements-worker.txt
RUN pip3 install --no-cache-dir --user --no-warn-script-location -r ./requirements-worker.txt


# ---- STAGE 2 ----
FROM ubuntu:22.04
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends vim python3 python3-pip libspatialindex-dev curl procps \
 && rm -rf /var/lib/apt/lists/*

# Copy built python packages
COPY --from=build-packages /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH

# Enviroment setup
ENV DEBIAN_FRONTEND=noninteractive
ENV OASIS_MEDIA_ROOT=/shared-fs
ENV OASIS_ENV_OVERRIDE=true

# Setup worker dir and user
RUN adduser --shell /bin/bash --disabled-password --gecos "" worker
WORKDIR /home/worker

# Copy in worker files
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

# Add required directories
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
