############################################################
# CompileBot Dockerfile
############################################################

# Instructions:
#
# Build Command: sudo docker build -t compilebot .

# Set the base image to Ubuntu
FROM python:2.7

# File Author / Maintainer
MAINTAINER Renfred Harper

# Update the sources list
RUN apt-get update && apt-get install --no-install-recommends -y tar git curl nano wget dialog net-tools build-essential && rm -rf /var/lib/apt/lists/*; # Install basic applications


# Clone compilebot
RUN git clone https://github.com/renfredxh/compilebot.git
WORKDIR /compilebot
RUN git submodule init
RUN git submodule update

# Get pip to download and install requirements:
RUN pip install --no-cache-dir -r requirements.txt

# Install ideone api library
WORKDIR lib/ideone-api
RUN python setup.py install

RUN cp /compilebot/compilebot/sample-config.yml /compilebot/compilebot/config.yml
WORKDIR /compilebot/compilebot

CMD python deploy.py
