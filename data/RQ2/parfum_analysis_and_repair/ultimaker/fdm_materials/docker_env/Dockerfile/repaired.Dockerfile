FROM --platform=linux/amd64 registry.hub.docker.com/library/debian:buster

LABEL Maintainer="software-embedded-platform@ultimaker.com" \
      Comment="Ultimaker update-tools filesystem"

RUN apt-get update && apt-get -y --no-install-recommends install cmake make python3 python3-pip git libxml2-dev libxslt-dev && rm -rf /var/lib/apt/lists/*;

COPY docker_env/buildenv_check.sh buildenv_check.sh

COPY fdm_requirements.txt fdm_requirements.txt

RUN pip3 install --no-cache-dir -r fdm_requirements.txt
