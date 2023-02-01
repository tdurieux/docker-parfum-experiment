# Ubuntu 12.04 (Precise) LTS with Git
#
# Version 0.1
#

# Ubuntu 12.04
FROM ubuntu:precise
MAINTAINER Nick Lothian nick.lothian@gmail.com


# GIT
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

