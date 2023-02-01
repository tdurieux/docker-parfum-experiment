# KaveToolbox 3.7-Beta on ubuntu 14
FROM ubuntu:14.04
MAINTAINER KAVE <kave@kpmg.com>
RUN apt-get update
RUN apt-get install --no-install-recommends -y wget curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python python-dev && rm -rf /var/lib/apt/lists/*;
RUN wget https://repos:kaverepos@repos.dna.kpmglab.com/noarch/KaveToolbox/3.7-Beta/kavetoolbox-installer-3.7-Beta.sh
RUN /bin/bash kavetoolbox-installer-3.7-Beta.sh --node
