FROM enspirit/webspicy:latest

USER root

RUN apk add --no-cache curl vim bash

WORKDIR /formalspec/

USER app

ENTRYPOINT []
CMD cd /formalspec/ && webspicy .
