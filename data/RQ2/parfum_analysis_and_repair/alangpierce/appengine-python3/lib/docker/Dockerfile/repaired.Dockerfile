FROM ubuntu:12.10
MAINTAINER Joffrey F <joffrey@dotcloud.com>
RUN apt-get update && yes | apt-get install -y --no-install-recommends python-pip && rm -rf /var/lib/apt/lists/*;
ADD . /home/docker-py
RUN cd /home/docker-py && pip install --no-cache-dir .
