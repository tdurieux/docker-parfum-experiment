# FROM  DOCKER_PACKAGES
# MAINTAINER "Antony Antony" <antony@phenome.org>
# ENV container docker
# setup ssh
RUN mkdir /root/.ssh
RUN mkdir -p /var/run/sshd
# create ssh host keys
RUN ssh-keygen -P '' -b 2048 -t rsa -f /etc/ssh/ssh_host_key
# move public key to enable ssh keys login
# copy the file /root/.ssh/authorized_keys to cwd
ADD testing/baseconfigs/all/root/.ssh/authorized_keys /root/.ssh/authorized_keys
RUN chmod 400 /root/.ssh/authorized_keys
RUN chown -R root:root /root/.ssh
# RUN systemctl disable sshd