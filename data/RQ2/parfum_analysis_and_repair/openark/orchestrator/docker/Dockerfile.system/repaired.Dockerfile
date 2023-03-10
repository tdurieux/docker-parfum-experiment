FROM golang:1.16.6-stretch
LABEL maintainer="openark@github.com"

RUN apt-get update -q -y && apt-get install --no-install-recommends -y sudo haproxy python git jq rsync libaio1 libnuma1 mysql-client bsdmainutils less vim && rm -rf /var/lib/apt/lists/*;

RUN mkdir /orchestrator
WORKDIR /orchestrator

RUN git clone https://github.com/openark/orchestrator-ci-env.git # cache

RUN (cd /orchestrator/orchestrator-ci-env && cp bin/linux/systemctl.py /usr/bin/systemctl)
RUN (cd /orchestrator/orchestrator-ci-env && script/deploy-haproxy)
RUN (cd /orchestrator/orchestrator-ci-env && script/deploy-consul)
RUN (cd /orchestrator/orchestrator-ci-env && script/deploy-consul-template)
RUN (cd /orchestrator/orchestrator-ci-env && script/deploy-heartbeat)

WORKDIR /orchestrator
COPY . .
RUN (cd /orchestrator && script/build)

CMD (cd /orchestrator/orchestrator-ci-env && script/docker-entry && cd /orchestrator && docker/docker-entry-system && /bin/bash)
