########################################
### Runbook.io - Monitors Dockerfile ###
########################################


# Pull base image
FROM ubuntu:14.04

# Update
RUN apt-get update --fix-missing
RUN apt-get upgrade -y

# Install python
RUN apt-get install --no-install-recommends -y python python-dev python-pip python-virtualenv wget unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libssl-dev libffi-dev && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /var/lib/apt/lists/*

# Create working directory
RUN mkdir -p /code
COPY config/* /config/
ADD requirements.txt /config/requirements.txt

# Install requirements
RUN pip install --no-cache-dir -r /config/requirements.txt
