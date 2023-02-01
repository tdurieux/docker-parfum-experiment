FROM ubuntu:14.04

MAINTAINER Brian Kellogg <theflakes@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get clean

# install SSH server and setup SSH for docker
# https://docs.docker.com/engine/examples/running_ssh_service/
RUN apt-get update && apt-get install --no-install-recommends -y openssh-server && rm -rf /var/lib/apt/lists/*;
RUN mkdir /var/run/sshd
RUN echo 'root:remnux' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# install remnux
RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends wget -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean
RUN wget --quiet -O - https://remnux.org/get-remnux.sh | sudo bash

VOLUME /tmp
VOLUME /data

EXPOSE 22

ENTRYPOINT ["/bin/sh"]
