ARG DOCKER_REGISTRY=docker-dev.yelpcorp.com/
FROM ${DOCKER_REGISTRY}ubuntu:bionic

ARG PIP_INDEX_URL=https://pypi.yelpcorp.com/simple
ENV PIP_INDEX_URL=$PIP_INDEX_URL

RUN sed -i 's/archive.ubuntu.com/us-east1.gce.archive.ubuntu.com/g' /etc/apt/sources.list

RUN apt-get update > /dev/null && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
        python3 \
        python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir pyramid
ADD httpdrain.py /httpdrain.py
CMD ["python3", "/httpdrain.py"]
