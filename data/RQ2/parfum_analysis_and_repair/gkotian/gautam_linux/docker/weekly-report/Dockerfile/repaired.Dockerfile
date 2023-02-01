FROM ubuntu:16.04

RUN apt-get update && apt-get -y --no-install-recommends install \
    python3 \
    python3-pip && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /setup/
RUN pip3 install --no-cache-dir -r /setup/requirements.txt

ENV IN_DOCKER_CONTAINER True
