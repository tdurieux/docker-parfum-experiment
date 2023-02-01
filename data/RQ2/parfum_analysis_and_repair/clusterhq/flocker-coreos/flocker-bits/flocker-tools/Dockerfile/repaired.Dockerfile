# dataset-agent Dockerfile
FROM clusterhq/flocker-core:1.8.0
MAINTAINER Madhuri Yechuri <madhuri.yechuri@clusterhq.com>

RUN sudo apt-get install --no-install-recommends -y python-pip build-essential libssl-dev libffi-dev python-dev && rm -rf /var/lib/apt/lists/*;
RUN sudo pip install --no-cache-dir git+https://github.com/clusterhq/unofficial-flocker-tools.git
RUN sudo pip install --no-cache-dir eliot-tree

# Tox - for unit testing storage driver
RUN sudo pip install --no-cache-dir tox