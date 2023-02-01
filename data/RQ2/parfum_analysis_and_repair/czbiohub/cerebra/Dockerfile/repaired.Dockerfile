# build as:
#   docker build -t cerebra .
#
# run as:
# 	docker run -it cerebra
#

#start off with a plain Debian
FROM ubuntu:latest

# basic setup stuff
RUN apt-get update && apt-get -y --no-install-recommends install autoconf automake make gcc perl zlib1g-dev libbz2-dev liblzma-dev libcurl4-gnutls-dev libssl-dev git python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y upgrade --fix-missing


# click library envs -- dont ask
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# cerebra proper
COPY . /cerebra
RUN cd /cerebra && pip3 install --no-cache-dir -r requirements.txt && python3 setup.py install && pip3 install --no-cache-dir -r test_requirements.txt
