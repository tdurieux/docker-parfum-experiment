# KaveToolbox 3.7-Beta on ubuntu 16
FROM ubuntu:xenial
MAINTAINER KAVE <kave@kpmg.com>
RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y
RUN apt-get install --no-install-recommends -y wget curl python python-dev && rm -rf /var/lib/apt/lists/*;
RUN wget https://repos:kaverepos@repos.dna.kpmglab.com/noarch/KaveToolbox/3.7-Beta/kavetoolbox-installer-3.7-Beta.sh
RUN /bin/bash kavetoolbox-installer-3.7-Beta.sh --node