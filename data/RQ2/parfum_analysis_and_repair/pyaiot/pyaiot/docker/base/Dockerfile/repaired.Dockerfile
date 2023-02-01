FROM python:3.7-slim-stretch

LABEL maintainer="alexandre.abadie@inria.fr"

RUN apt-get update && apt-get install --no-install-recommends -y git && apt-get autoremove && apt-get autoclean && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir git+https://github.com/pyaiot/pyaiot.git

RUN aiot-generate-keys
