#ARG BUILD_FROM
#FROM $BUILD_FROM
FROM python:3

ENV LANG C.UTF-8

#RUN apk add --no-cache python3
#RUN apk add --no-cache py3-pip