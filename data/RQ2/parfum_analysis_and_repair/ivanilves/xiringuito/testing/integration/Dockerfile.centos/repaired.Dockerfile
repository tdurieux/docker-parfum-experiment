FROM centos:7

LABEL maintainer "ivan.ilves@gmail.com"

RUN yum -y install openssh-server openssh-clients sudo iproute iputils iptables \
  && ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa \
  && mkdir -p /lib/systemd/system && touch /lib/systemd/system/ssh.service \
  && rm /sbin/modprobe && ln -s /bin/true /sbin/modprobe \
  && yum clean all && rm -rf /var/cache/yum

ADD ./ssh-keys /root/.ssh
ADD ./systemctl.mock /bin/systemctl

CMD ["/usr/sbin/sshd", "-De"]
