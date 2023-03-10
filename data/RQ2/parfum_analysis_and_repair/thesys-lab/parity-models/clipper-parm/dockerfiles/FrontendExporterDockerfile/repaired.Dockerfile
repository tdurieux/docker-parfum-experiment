# This ARG isn't used but prevents warnings in the build script
ARG CODE_VERSION
FROM python:3.6-slim-stretch

LABEL maintainer="Dan Crankshaw <dscrankshaw@gmail.com>"

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

RUN pip install --no-cache-dir requests==2.18.* prometheus_client==0.1.* flatten_json==0.1.*

COPY monitoring/front_end_exporter.py /usr/src/app
ENTRYPOINT ["python", "/usr/src/app/front_end_exporter.py"]

# vim: set filetype=dockerfile:
