# This is a Dockerfile that standardizes the project's development environment
# and makes it cross-os/platform.
#
# Built image live at: https://hub.docker.com/r/daostack/arc/
#
# author: Matan Tsuberi <dev.matan.tsuberi@gmail.com>

FROM node:9.5.0

LABEL maintainer="Matan Tsuberi <dev.matan.tsuberi@gmail.com>"

VOLUME /home/arc
WORKDIR /home/arc

# install mkdocs & mkdocs-material
RUN apt-get -y -qq update && apt-get -y --no-install-recommends -qq install python-pip build-essential libssl-dev libffi-dev python-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir mkdocs mkdocs-material

# truffle
RUN npm i -g truffle ganache-cli && npm cache clean --force;

# clone the project if not cloned, else fetch latest. in any case install all `package.json` deps.
CMD (git -C . fetch || git clone https://github.com/daostack/arc.git .) && npm i && /bin/bash
