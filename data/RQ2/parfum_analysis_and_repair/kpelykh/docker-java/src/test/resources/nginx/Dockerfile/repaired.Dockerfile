# Nginx
#
# VERSION               0.0.1

FROM      ubuntu
MAINTAINER Guillaume J. Charmes "guillaume@dotcloud.com"

# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update && apt-get install --no-install-recommends -y inotify-tools nginx apache2 openssh-server && rm -rf /var/lib/apt/lists/*;