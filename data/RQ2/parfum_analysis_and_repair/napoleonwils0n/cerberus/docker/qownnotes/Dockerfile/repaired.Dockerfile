# run QownNotes in docker

FROM debian:jessie
MAINTAINER username <username@gmail.com>

RUN apt-get update && \
 apt-get install --no-install-recommends -y wget && \
 wget https://download.opensuse.org/repositories/home:/pbek:/QOwnNotes/Debian_8.0/Release.key -O - | apt-key add - && \
echo 'deb http://download.opensuse.org/repositories/home:/pbek:/QOwnNotes/Debian_8.0/ /' >> /etc/apt/sources.list.d/qownnotes.list && \
apt-get update && \
 apt-get install --no-install-recommends -y qownnotes \
&& mkdir -p /root/ownCloud/Notes \
&& rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "QOwnNotes" ]
