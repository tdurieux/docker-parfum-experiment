# 20.04.1 LTS
FROM ubuntu:20.04


#
# Based on some instructions found at https://gist.github.com/pokle/10808069
#
# This first step will build a common image that this and the other Ubuntu
# image will share and save on build time and disk space.
#
RUN apt-get update && \
	apt-get install --no-install-recommends -y openssh-server && \
	mkdir /run/sshd && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y netcat-openbsd && rm -rf /var/lib/apt/lists/*;

CMD /usr/sbin/sshd -D


