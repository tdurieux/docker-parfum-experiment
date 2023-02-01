FROM REPLACE_BASE_CENTOS

ENV DEBIAN_FRONTEND=noninteractive
ENV CB_SSH_PUB_KEY=NA
ENV CB_LOGIN=NA

# sudo-install-man
RUN yum install -y sudo && rm -rf /var/cache/yum
# echo "USERNAME  ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers; sed -i s/"Defaults requiretty"/"#Defaults requiretty"/g /etc/sudoers
# sudo-install-man

# ifconfig-install-sl
RUN yum -y update; yum clean all
RUN yum install -y net-tools && rm -rf /var/cache/yum
RUN ln -sf /sbin/ifconfig /usr/local/bin/ifconfig
# ifconfig-install-sl

# ip-install-sl
RUN ln -sf /sbin/ip /usr/local/bin/ip
# ip-install-sl

# pkill-install-pm
RUN yum install -y psmisc coreutils && rm -rf /var/cache/yum
# pkill-install-pm

# which-install-pm
RUN /bin/true
# which-install-pm

# ntp-install-pm
RUN yum install -y ntp ntpdate && rm -rf /var/cache/yum
# ntp-install-pm

# git-install-pm
RUN yum install -y git && rm -rf /var/cache/yum
# git-install-pm

# wget-install-pm
RUN yum install -y wget && rm -rf /var/cache/yum
# wget-install-pm

# pip-install-pm
RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum install -y python3-pip && rm -rf /var/cache/yum
# pip-install-pm

# gcc-install-pm
RUN yum install -y gcc && rm -rf /var/cache/yum
# gcc-install-pm

# make-install-pm
RUN yum install -y make && rm -rf /var/cache/yum
# make-install-pm

# bc-install-pm
RUN yum install -y bc && rm -rf /var/cache/yum
# bc-install-pm

# sshpass-install-pm
RUN yum install -y sshpass && rm -rf /var/cache/yum
# sshpass-install-pm

# curl-install-pm
RUN yum install -y curl && rm -rf /var/cache/yum
# curl-install-pm

# screen-install-pm
RUN yum install -y screen && rm -rf /var/cache/yum
# screen-install-pm

# rsync-install-pm
RUN yum install -y rsync && rm -rf /var/cache/yum
# rsync-install-pm

# ncftp-install-pm
RUN yum install -y ncftp && rm -rf /var/cache/yum
# ncftp-install-pm

# lftp-install-pm
RUN yum install -y lftp iputils-ping && rm -rf /var/cache/yum
# lftp-install-pm

# haproxy-install-pm
RUN yum install -y haproxy && rm -rf /var/cache/yum
# service_stop_disable haproxy
# haproxy-install-pm

RUN yum install -y vim && rm -rf /var/cache/yum

# netcat-install-man
RUN yum install -y nmap-ncat netcat-openbsd && rm -rf /var/cache/yum
RUN cp /bin/nc /usr/local/bin/netcat
# netcat-install-man

# nmap-install-pm
RUN yum install -y nmap && rm -rf /var/cache/yum
# nmap-install-pm

# openvpn-install-pm
RUN yum install -y openvpn && rm -rf /var/cache/yum
RUN ln -sf /usr/sbin/openvpn /usr/local/bin/openvpn
# openvpn-install-pm

# gmond-install-pm
RUN yum install -y ganglia ganglia-gmond.REPLACE_ARCH1 && rm -rf /var/cache/yum
RUN ln -sf /usr/sbin/gmond /usr/local/bin/gmond
# service_stop_disable gmond
# gmond-install-pm

# rsyslog-install-pm
RUN yum install -y rsyslog && rm -rf /var/cache/yum
RUN ln -sf $(sudo which rsyslogd) /usr/local/bin/rsyslogd
# rsyslog-install-pm

# apache-install-pm
RUN yum -y install httpd; rm -rf /var/cache/yum /bin/true
# apache-install-pm

# redis-install-pm
RUN yum install -y redis && rm -rf /var/cache/yum
RUN sed -i "s/.*bind 127.0.0.1/bind 0.0.0.0/" /etc/redis.conf
# redis-install-pm

# python3-devel-install-pm
RUN yum install -y python3-devel libffi-devel openssl-devel libxml2-devel && rm -rf /var/cache/yum
# python3-devel-install-pm

# python-prettytable-install-pip
RUN pip3 install --no-cache-dir --upgrade docutils prettytable
# python-prettytable-install-pip

# python-daemon-install-pip
RUN pip3 install --no-cache-dir --upgrade python-daemon==2.1.2
# python-daemon-install-pip

# python-twisted-install-pip
RUN pip3 install --no-cache-dir --upgrade twisted
# python-twisted-install-pip

# python-beaker-install-pip
RUN pip3 install --no-cache-dir --upgrade beaker
# python-beaker-install-pip

# python-webob-install-pip
RUN pip3 install --no-cache-dir --upgrade webob
# python-webob-install-pip

# pyredis-install-pip
RUN pip3 install --no-cache-dir redis
# pyredis-install-pip

# pymongo-install-pip
RUN pip3 install --no-cache-dir --upgrade mongo
# pymongo-install-pip

# pssh-install-pm
RUN yum install -y pssh && rm -rf /var/cache/yum
# pssh-install-pm

# docutils-install-pip
RUN pip3 install --no-cache-dir --upgrade docutils
# docutils-install-pip

# python-setuptools-install-pip
RUN pip3 install --no-cache-dir --upgrade setuptools
# python-setuptools-install-pip

# markup-install-pip
RUN pip3 install --no-cache-dir --upgrade markup
# markup-install-pip

# pyyaml-install-pip
RUN pip3 install --no-cache-dir --upgrade pyyaml
# pyyaml-install-pip

# ruamelyaml-install-pip
RUN pip3 install --no-cache-dir --upgrade ruamel.yaml
# ruamelyaml-install-pip

# iptables-install-pm
RUN yum install -y iptables && rm -rf /var/cache/yum
# service_stop_disable iptables
# iptables-install-pm

# jq-install-pm
RUN yum install -y jq && rm -rf /var/cache/yum
# jq-install-pm

# sshd-install-pm
RUN yum -y install openssh-server && rm -rf /var/cache/yum
RUN sudo bash -c "echo 'UseDNS no' >> /etc/ssh/sshd_config"
RUN sed -i 's/.*UseDNS.*/UseDNS no/g' /etc/ssh/sshd_config
RUN sed -i 's/.*GSSAPIAuthentication.*/GSSAPIAuthentication no/g' /etc/ssh/sshd_config
# sshd-install-pm

RUN rsync -az /root/.ssh/ /home/REPLACE_USERNAME/.ssh/
# sshconfig-install-man
RUN mkdir -p ~/.ssh
RUN chmod 700 ~/.ssh
RUN echo "StrictHostKeyChecking=no" > /home/REPLACE_USERNAME/.ssh/config
RUN echo "UserKnownHostsFile=/dev/null" >> /home/REPLACE_USERNAME/.ssh/config
RUN chmod 600 /home/REPLACE_USERNAME/.ssh/config
# sshconfig-install-man
RUN chown -R REPLACE_USERNAME:REPLACE_USERNAME /home/REPLACE_USERNAME/

USER REPLACE_USERNAME
WORKDIR /home/REPLACE_USERNAME/
#RUN GIT_TRACE=1; GIT_CURL_VERBOSE=1 git clone --verbose http://github.com/ibmcb/cbtool.git
RUN git clone https://github.com/ibmcb/cbtool.git; cd cbtool; git checkout REPLACE_BRANCH
RUN mkdir -p /home/REPLACE_USERNAME/cbtool/3rd_party

# gmetad-python-install-git
WORKDIR /home/REPLACE_USERNAME/cbtool/3rd_party
RUN git clone https://github.com/ibmcb/monitor-core.git
# gmetad-python-install-git

#pyhtml-install-git
WORKDIR /home/REPLACE_USERNAME/cbtool/3rd_party
RUN git clone https://github.com/ibmcb/HTML.py.git
WORKDIR /home/REPLACE_USERNAME/cbtool/3rd_party/HTML.py
RUN sudo python3 setup.py install
#pyhtml-install-git

WORKDIR /home/REPLACE_USERNAME
USER root
RUN chown -R REPLACE_USERNAME:REPLACE_USERNAME /home/REPLACE_USERNAME
