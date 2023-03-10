FROM centos:8

#
# Based on some instructions found at https://gist.github.com/pokle/10808069
#
RUN yum install -y openssh-server nmap-ncat && \
	ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' && \
	ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -N '' && rm -rf /var/cache/yum

CMD /usr/sbin/sshd -D

