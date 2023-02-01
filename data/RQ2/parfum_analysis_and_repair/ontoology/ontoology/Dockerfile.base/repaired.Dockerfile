FROM openjdk:19-alpine
RUN mkdir -p playground ;\
    chmod 777 playground ; \
    mkdir -p playground/OnToology
WORKDIR /playground/OnToology
COPY scripts scripts
COPY *.sh ./
COPY *.txt ./
RUN sh scripts/setup_docker_base.sh