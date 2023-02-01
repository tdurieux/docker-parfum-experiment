FROM python:3.8-slim
RUN mkdir -p playground
RUN chmod 777 playground
RUN mkdir -p playground/OnToology
WORKDIR /playground/OnToology
COPY scripts scripts
COPY *.sh ./
COPY *.txt ./
RUN sh scripts/setup_docker_base.sh