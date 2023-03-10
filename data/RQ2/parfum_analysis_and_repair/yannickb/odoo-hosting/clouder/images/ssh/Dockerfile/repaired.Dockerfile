FROM clouder/base:3.4
MAINTAINER Yannick Buron yannick.buron@gmail.com

RUN touch /tmp/odoo-ssh
RUN apk add --no-cache --update openssh
RUN mkdir /var/run/sshd
RUN chmod 0755 /var/run/sshd
RUN /usr/bin/ssh-keygen -A
USER root

CMD /usr/sbin/sshd -ddd