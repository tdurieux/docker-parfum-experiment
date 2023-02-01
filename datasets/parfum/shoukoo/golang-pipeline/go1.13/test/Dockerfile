FROM golang:1.13.4-alpine

LABEL name="Golang Pipeline"
LABEL maintainer="Shoukoo"
LABEL version="0.2.8"
LABEL repository="https://github.com/shoukoo/golang-pipeline"

LABEL com.github.actions.name="Golang Pipeline"
LABEL com.github.actions.description="Run Golang commands"
LABEL com.github.actions.icon="box"
LABEL com.github.actions.color="blue"

COPY entrypoint.sh /entrypoint.sh
COPY gp-setup.sh /gp-setup.sh

RUN apk add --no-cache curl jq git build-base
ENTRYPOINT ["/entrypoint.sh"]
