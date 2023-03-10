# First build stage: get gemu for multi-arch building
FROM alpine AS qemu

#QEMU Download
ENV QEMU_URL https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-aarch64.tar.gz
RUN apk add --no-cache curl && curl -f -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1

# New build stage: Basis-Image
FROM arm64v8/python:3.8.2-slim-buster

# Provide QEMU for this stage of docker build
COPY --from=qemu qemu-aarch64-static /usr/bin

LABEL maintainer="marcel.beining@gmail.com"

RUN apt-get update \
	&& apt-get -y --no-install-recommends install curl build-essential libssl-dev python-dev libffi-dev \
    && apt-get clean \
    && pip install --no-cache-dir --upgrade pip && rm -rf /var/lib/apt/lists/*;

# Prepare environment
WORKDIR /eazebot_docker

ENV LD_LIBRARY_PATH /usr/local/lib
ENV IN_DOCKER_CONTAINER Yes

# Install dependencies
COPY requirements.txt /eazebot_docker/
RUN pip install -r /eazebot_docker/requirements.txt --no-cache-dir

# Install and execute
# take the files and folders in local build context and add them to the Docker image’s current working directory.
COPY . /eazebot_docker/
RUN pip install -e /eazebot_docker --no-cache-dir

ENTRYPOINT ["python", "/eazebot_docker/eazebot/main.py"]

CMD []
