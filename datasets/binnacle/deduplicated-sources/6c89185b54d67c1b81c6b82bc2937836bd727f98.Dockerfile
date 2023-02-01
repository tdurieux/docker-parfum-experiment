# - run sshd with builder user's public key
#   so that builder can ssh directly in as root
#
FROM ubuntu:14.04

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN sed -i \
  's/PermitRootLogin without-password/PermitRootLogin yes/' \
  /etc/ssh/sshd_config
RUN sed -i \
  's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' \
  /etc/pam.d/sshd
RUN mkdir /root/.ssh
COPY ./tmp/id_rsa.pub /root/.ssh/authorized_keys
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
