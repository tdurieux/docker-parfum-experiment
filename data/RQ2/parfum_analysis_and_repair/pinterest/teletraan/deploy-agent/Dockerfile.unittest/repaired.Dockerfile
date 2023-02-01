FROM ubuntu:18.04

RUN apt-get update
RUN apt-get upgrade

RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential python-dev python-setuptools python3-dev python3-setuptools python-pip python3-pip tox && rm -rf /var/lib/apt/lists/*;

# fixme: python3 tests currently need curl to pass
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

ENV PROJECT_DIR=/opt/deploy-agent
RUN mkdir $PROJECT_DIR
WORKDIR $PROJECT_DIR
ADD . $PROJECT_DIR

# nb: tox.ini setting recreate=True does not seem to be respected in docker
RUN rm -rf .tox

ENTRYPOINT ["bash", "-c", "tox"]
