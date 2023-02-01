FROM open-path-warehouse:latest--base

USER root
RUN apk add --no-cache py3-pip
RUN pip3 install --no-cache-dir awscli
USER app
