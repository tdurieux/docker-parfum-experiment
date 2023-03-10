FROM centos:7

RUN yum install -y -q sudo vim tree && rm -rf /var/cache/yum
RUN curl -fsSL https://repo.stns.jp/scripts/yum-repo.sh | sh
RUN yum install -y -q stns-v2 libnss-stns-v2 openssh-server && rm -rf /var/cache/yum

ADD client/stns.conf /etc/stns/client/stns.conf
ADD client/nsswitch.conf /etc/nsswitch.conf
ADD client/sshd_config /etc/ssh/sshd_config

CMD ["/usr/sbin/init"]
