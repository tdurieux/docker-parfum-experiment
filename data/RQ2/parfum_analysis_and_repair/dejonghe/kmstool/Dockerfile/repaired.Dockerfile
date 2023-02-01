FROM ubuntu:trusty
# Python requirements
RUN apt-get update && \
    apt-get install --no-install-recommends -y python python-dev python-pip gcc && rm -rf /var/lib/apt/lists/*;

# Setup Deployer
ADD / /kmstool
WORKDIR /kmstool
RUN python setup.py sdist
RUN pip install --no-cache-dir dist/kmstool-1.3.1.tar.gz

# Prep workspace
RUN mkdir /workspace
WORKDIR /workspace
VOLUME /workspace
