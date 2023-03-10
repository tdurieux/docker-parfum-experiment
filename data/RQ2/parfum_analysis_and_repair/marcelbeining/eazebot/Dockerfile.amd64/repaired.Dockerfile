# New build stage: Basis-Image
FROM python:3.8.2-slim-buster

LABEL maintainer="marcel.beining@gmail.com"

RUN apt-get update \
    && apt-get clean \
    && pip install --no-cache-dir --upgrade pip

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

