FROM node:16-bullseye-slim

ARG DEBIAN_FRONTEND=noninteractive

ARG CONTAINER_USER=reconmapper
ARG CONTAINER_GROUP=reconmapper

ARG HOST_UID=1000
ARG HOST_GID=1000

RUN userdel -r node && \
    groupadd -g ${HOST_GID} ${CONTAINER_GROUP} && \
    useradd -u ${HOST_UID} -g ${CONTAINER_GROUP} -s /bin/sh -m ${CONTAINER_USER}

RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

ENV DISABLE_OPENCOLLECTIVE true
ENV PATH /home/reconmapper/node_modules/.bin:$PATH

WORKDIR /home/reconmapper
USER reconmapper
