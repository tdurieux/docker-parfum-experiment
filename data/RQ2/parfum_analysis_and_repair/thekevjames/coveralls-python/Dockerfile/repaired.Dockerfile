ARG COVERALLS=coveralls

FROM python:3.10-alpine

ARG COVERALLS
RUN apk add --no-cache --update git && \
    python3 -m pip install "${COVERALLS}"
