# docker build -t cogrob/ebt-dep .
# docker export ebt-dep | gzip -c > ebt-dep.tgz
# docker import ebt-dep < ebt-dep.tgz

############################################################
# Dockerfile to build EBT images
# Based on Ubuntu
############################################################

FROM ubuntu:14.04
MAINTAINER Cognitive Robotics "http://cogrob.org/"

# Intall some basic tools
RUN apt-get update && apt-get install --no-install-recommends -y \
	curl \
	screen \
	byobu \
	fish \
	git \
	nano \
	glances && rm -rf /var/lib/apt/lists/*;

CMD ["bash"]