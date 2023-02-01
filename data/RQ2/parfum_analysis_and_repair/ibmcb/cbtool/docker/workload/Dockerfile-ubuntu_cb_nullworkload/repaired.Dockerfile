FROM REPLACE_BASE_UBUNTU

ENV DEBIAN_FRONTEND=noninteractive
ENV CB_SSH_PUB_KEY=NA
ENV CB_LOGIN=NA

# sudo-install-man
RUN apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
# echo "USERNAME  ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers; sed -i s/"Defaults requiretty"/"#Defaults requiretty"/g /etc/sudoers
# sudo-install-man

# ifconfig-install-sl
RUN apt-get update
RUN apt-get install --no-install-recommends -y net-tools && rm -rf /var/lib/apt/lists/*;
RUN ln -sf /sbin/ifconfig /usr/local/bin/ifconfig
# ifconfig-install-sl

# ip-install-sl
RUN ln -sf /sbin/ip /usr/local/bin/ip
# ip-install-sl

# pkill-install-pm
RUN apt-get install --no-install-recommends -y psmisc coreutils && rm -rf /var/lib/apt/lists/*;
# pkill-install-pm

# which-install-pm
RUN /bin/true
# which-install-pm

# ntp-install-pm
RUN apt-get install --no-install-recommends -y ntp ntpdate && rm -rf /var/lib/apt/lists/*;
# ntp-install-pm

# git-install-pm
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
# git-install-pm

# wget-install-pm
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
# wget-install-pm

# pip-install-pm
RUN apt-get update
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
# pip-install-pm

# gcc-install-pm
RUN apt-get install --no-install-recommends -y gcc && rm -rf /var/lib/apt/lists/*;
# gcc-install-pm

# make-install-pm
RUN apt-get install --no-install-recommends -y make && rm -rf /var/lib/apt/lists/*;
# make-install-pm

# bc-install-pm
RUN apt-get install --no-install-recommends -y bc && rm -rf /var/lib/apt/lists/*;
# bc-install-pm

# sshpass-install-pm
RUN apt-get install --no-install-recommends -y sshpass && rm -rf /var/lib/apt/lists/*;
# sshpass-install-pm

# curl-install-pm
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
# curl-install-pm

# screen-install-pm
RUN apt-get install --no-install-recommends -y screen && rm -rf /var/lib/apt/lists/*;
# screen-install-pm

# rsync-install-pm
RUN apt-get install --no-install-recommends -y rsync && rm -rf /var/lib/apt/lists/*;
# rsync-install-pm

# ncftp-install-pm
RUN apt-get install --no-install-recommends -y ncftp && rm -rf /var/lib/apt/lists/*;
# ncftp-install-pm

# lftp-install-pm
RUN apt-get install --no-install-recommends -y lftp iputils-ping && rm -rf /var/lib/apt/lists/*;
# lftp-install-pm

# haproxy-install-pm
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:vbernat/haproxy-2.0
RUN apt-get update
RUN apt-get install --no-install-recommends -y haproxy && rm -rf /var/lib/apt/lists/*;
# service_stop_disable haproxy
# haproxy-install-pm

RUN apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;

# netcat-install-man
RUN apt-get install --no-install-recommends -y netcat-openbsd && rm -rf /var/lib/apt/lists/*;
RUN cp /bin/nc /usr/local/bin/netcat
# netcat-install-man

# nmap-install-pm
RUN apt-get install --no-install-recommends -y nmap && rm -rf /var/lib/apt/lists/*;
# nmap-install-pm

# openvpn-install-pm
RUN apt-get install --no-install-recommends -y openvpn && rm -rf /var/lib/apt/lists/*;
RUN ln -sf /usr/sbin/openvpn /usr/local/bin/openvpn
# openvpn-install-pm

# gmond-install-pm
RUN apt-get install --no-install-recommends -y ganglia-monitor && rm -rf /var/lib/apt/lists/*;
RUN ln -sf /usr/sbin/gmond /usr/local/bin/gmond
# service_stop_disable ganglia-monitor
# gmond-install-pm

# rsyslog-install-pm
RUN apt-get install --no-install-recommends -y rsyslog && rm -rf /var/lib/apt/lists/*;
RUN ln -sf $(sudo which rsyslogd) /usr/local/bin/rsyslogd
RUN mkdir -p /var/log/cloudbench
# rsyslog-install-pm

# apache-install-pm
RUN apt-get install --no-install-recommends -y apache2 && rm -rf /var/lib/apt/lists/*;
# apache-install-pm

# redis-install-pm
RUN apt-get install --no-install-recommends -y redis-server && rm -rf /var/lib/apt/lists/*;
RUN sed -i "s/.*bind 127.0.0.1/bind 0.0.0.0/" /etc/redis/redis.conf
# redis-install-pm

# python3-devel-install-pm
RUN apt-get install --no-install-recommends -y python3-dev libffi-dev libssl-dev libxml2-dev libxslt1-dev libjpeg8-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*;
# python3-devel-install-pm

# python-prettytable-install-pip
RUN pip3 install --no-cache-dir --upgrade docutils prettytable
# python-prettytable-install-pip

# python-daemon-install-pip
RUN pip3 install --no-cache-dir --upgrade python-daemon-3K
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

# python3-pymongo-ext-install-pm
RUN apt-get install --no-install-recommends -y python3-pymongo-ext && rm -rf /var/lib/apt/lists/*;
# python3-pymongo-ext-install-pm

# mysql-server-install-pm
RUN apt-get install --no-install-recommends -y mysql-server && rm -rf /var/lib/apt/lists/*;
# mysql-server-install-pm

# python-mysql-connector-install-pip
RUN pip3 install --no-cache-dir --upgrade mysql-connector
# python-mysql-connector-install-pip

# pssh-install-pm
RUN apt-get install --no-install-recommends -y pssh && rm -rf /var/lib/apt/lists/*;
# pssh-install-pm

# docutils-install-pip
RUN pip3 install --no-cache-dir --upgrade docutils
# docutils-install-pip

# python3-setuptools-install-pip
RUN pip3 install --no-cache-dir --upgrade setuptools
# python3-setuptools-install-pip

# markup-install-pip
RUN pip3 install --no-cache-dir --upgrade markup
# markup-install-pip

# pyyaml-install-pip
RUN pip3 install --no-cache-dir --upgrade pyyaml
# pyyaml-install-pip

# jq-install-pm
RUN apt-get install --no-install-recommends -y jq && rm -rf /var/lib/apt/lists/*;
# jq-install-pm

# ruamelyaml-install-pip
RUN pip3 install --no-cache-dir --upgrade ruamel.yaml
# ruamelyaml-install-pip

# iptables-install-pm
RUN apt-get install --no-install-recommends -y iptables && rm -rf /var/lib/apt/lists/*;
# service_stop_disable iptables
# iptables-install-pm

# sshd-install-pm
RUN apt-get install --no-install-recommends -y openssh-server && rm -rf /var/lib/apt/lists/*;
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
RUN chown -R REPLACE_USERNAME:REPLACE_USERNAME /home/REPLACE_USERNAME/.ssh/config
# sshconfig-install-man
RUN chown -R REPLACE_USERNAME:REPLACE_USERNAME /home/REPLACE_USERNAME/

USER REPLACE_USERNAME
WORKDIR /home/REPLACE_USERNAME/
RUN git clone https://github.com/ibmcb/cbtool.git; cd cbtool; git checkout REPLACE_BRANCH

# gmetad-python-install-git
RUN mkdir -p /home/REPLACE_USERNAME/cbtool/3rd_party
WORKDIR /home/REPLACE_USERNAME/cbtool/3rd_party
RUN git clone https://github.com/ibmcb/monitor-core.git
# gmetad-python-install-git

# pyhtml-install-git
WORKDIR /home/REPLACE_USERNAME/cbtool/3rd_party
RUN git clone https://github.com/ibmcb/HTML.py.git
WORKDIR /home/REPLACE_USERNAME/cbtool/3rd_party/HTML.py
RUN sudo python3 setup.py install
# pyhtml-install-git

WORKDIR /home/REPLACE_USERNAME
USER root
RUN chown -R REPLACE_USERNAME:REPLACE_USERNAME /home/REPLACE_USERNAME
