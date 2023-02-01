ARG BASE_IMAGE

FROM $BASE_IMAGE

USER root

RUN apk add --no-cache curl

USER 10101