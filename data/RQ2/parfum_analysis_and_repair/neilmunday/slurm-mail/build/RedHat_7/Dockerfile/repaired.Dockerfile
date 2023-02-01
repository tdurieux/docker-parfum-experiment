FROM centos:7

RUN yum -y install rpm-build tar && rm -rf /var/cache/yum

RUN mkdir -p /root/slurm-mail

CMD ["/usr/bin/tail", "-f", "/dev/null"]
