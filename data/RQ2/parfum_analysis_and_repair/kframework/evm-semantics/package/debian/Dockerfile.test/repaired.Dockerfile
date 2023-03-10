ARG BASE_IMAGE=ubuntu:focal
FROM ${BASE_IMAGE}
ARG BASE_IMAGE=ubuntu:focal

ENV TZ=America/Chicago
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update        \
    && apt-get upgrade --yes \
    && apt-get install --no-install-recommends --yes \
        git \
        make \
        sudo && rm -rf /var/lib/apt/lists/*;

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ARG USER_ID=1000
ARG GROUP_ID=1000
RUN    groupadd -g $GROUP_ID user                             \
    && useradd -m -u $USER_ID -s /bin/sh -g user user -G sudo

USER $USER_ID:$GROUP_ID
WORKDIR /home/user
