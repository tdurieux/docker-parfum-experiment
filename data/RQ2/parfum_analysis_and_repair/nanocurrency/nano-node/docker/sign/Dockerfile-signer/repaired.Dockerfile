FROM python:3.9-buster


ENV DEBIAN_FRONTEND="noninteractive"
ENV TZ="America/Los_Angeles"
ENV GPG_TTY=/dev/console

ARG GPG_PRIVATE_KEY
ARG GPG_SIGNER

## Install required for rpm signing
RUN apt-get update -yqq && \
    apt-get install --no-install-recommends -y librpmsign8 gnupg2 wget rpm && rm -rf /var/lib/apt/lists/*;

## Additional for mkrepo support
RUN python3 -m pip install mkrepo boto3

#WORKDIR /signing
#RUN python3 -m venv && .venv/bin/pip install mkrepo

## Control Entrypoint
ADD docker/sign/entry.sh /usr/local/bin/entry.sh

ENTRYPOINT [ "entry.sh" ]
