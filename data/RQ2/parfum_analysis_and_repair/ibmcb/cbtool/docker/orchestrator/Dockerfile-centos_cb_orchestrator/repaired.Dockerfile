FROM REPLACE_BASE_VANILLA_CENTOS
RUN yum -y update
RUN yum -y install openssh-server && rm -rf /var/cache/yum
RUN yum -y install passwd && rm -rf /var/cache/yum
RUN yum -y install sudo && rm -rf /var/cache/yum
RUN yum -y install rsync && rm -rf /var/cache/yum

RUN useradd -ms /bin/bash REPLACE_USERNAME
RUN echo "REPLACE_USERNAME  ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

#ENV OBJECTSTORE_PORT=10000
#ENV METRICSTORE_PORT=20000
#ENV LOGSTORE_PORT=30000
#ENV FILESTORE_PORT=40000
#ENV GUI_PORT=50000
#ENV API_PORT=60000
#ENV VPN_PORT=65000

#EXPOSE $OBJECTSTORE_PORT
#EXPOSE $METRICSTORE_PORT
#EXPOSE $LOGSTORE_PORT
#EXPOSE $FILESTORE_PORT
#EXPOSE $GUI_PORT
#EXPOSE $API_PORT
#EXPOSE $VPN_PORT

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
RUN yum install -y gcc gcc-c++ && rm -rf /var/cache/yum
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
RUN yum install -y lftp && rm -rf /var/cache/yum
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
RUN cd /root/; wget -N https://mirrors.lug.mtu.edu/fedora/linux/development/rawhide/Everything/source/tree/Packages/g/ganglia-3.7.2-31.fc33.src.rpm
RUN yum install -y perl-Pod-Html-1.22.02-416.el8.noarch rpm-build autoconf automake libtool apr-devel && rm -rf /var/cache/yum
RUN yum install -y rsync rrdtool-devel rpcgen libtirpc-devel libmemcached-devel libconfuse-devel && rm -rf /var/cache/yum
RUN wget -N https://download.fedoraproject.org/pub/fedora/linux/development/rawhide/Everything/source/tree/Packages/l/libart_lgpl-2.3.21-23.fc32.src.rpm
RUN cd /root/; rpmbuild --rebuild libart_lgpl-2.3.21-23.fc32.src.rpm
RUN yum install -y /root/rpmbuild/RPMS/x86_64/libart_lgpl-2.3.21-23.el8.x86_64.rpm /root/rpmbuild/RPMS/x86_64/libart_lgpl-devel-2.3.21-23.el8.x86_64.rpm && rm -rf /var/cache/yum
RUN yum install -y git && rm -rf /var/cache/yum
RUN cd /root/; rpmbuild --rebuild ganglia-3.7.2-31.fc33.src.rpm
RUN yum install -y /root/rpmbuild/RPMS/x86_64/ganglia-3.7.2-31.el8.x86_64.rpm /root/rpmbuild/RPMS/x86_64/ganglia-gmetad-3.7.2-31.el8.x86_64.rpm /root/rpmbuild/RPMS/x86_64/ganglia-gmond-3.7.2-31.el8.x86_64.rpm && rm -rf /var/cache/yum
# service_stop_disable gmond
# gmond-install-pm

# rsyslog-install-pm
RUN yum install -y rsyslog && rm -rf /var/cache/yum
RUN ln -sf /sbin/rsyslogd /usr/local/bin/rsyslogd
# rsyslog-install-pm

# apache-install-pm
RUN yum -y install httpd; rm -rf /var/cache/yum /bin/true
# apache-install-pm

# redis-install-pm
RUN yum install -y redis && rm -rf /var/cache/yum
RUN sed -i "s/.*bind 127.0.0.1/bind 0.0.0.0/" /etc/redis.conf
# redis-install-pm
RUN sed -i "s/.*port.*/port $OBJECTSTORE_PORT/" /etc/redis.conf

# mongodb-install-pm
RUN yum install -y mongodb-org-tools mongodb-org-shell mongodb-org-server && rm -rf /var/cache/yum
RUN sed -i "s/.*bind_ip.*/bind_ip=0.0.0.0/" /etc/mongod.conf; /bin/true
RUN sed -i "s/.*port.*/port = $METRICSTORE_PORT/" /etc/mongod.conf; /bin/true
# mongodb-install-pm

# pylibvirt-install-pm
RUN yum install -y libvirt-python3 && rm -rf /var/cache/yum
# pylibvirt-install-pm

# pypureomapi-install-pip
RUN pip3 install --no-cache-dir --upgrade pypureomapi
# pypureomapi-install-pip

# python3-devel-install-pm
RUN yum install -y python3-devel libffi-devel openssl-devel libxml2-devel && rm -rf /var/cache/yum
# python3-devel-install-pm

# python-prettytable-install-pip
RUN pip3 install --no-cache-dir --upgrade docutils prettytable wheel
# python-prettytable-install-pip

# python-daemon-install-pip
RUN pip3 install --no-cache-dir --upgrade python-daemon-3K
# python-daemon-install-pip

# python-twisted-install-pip
RUN pip3 install --no-cache-dir --upgrade twisted service_identity
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
RUN yum install -y mpssh && rm -rf /var/cache/yum
RUN sudo ln -sf /usr/bin/mpssh /usr/local/bin/pssh
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

# urllib3-install-pip
RUN pip3 install --no-cache-dir --upgrade  urllib3[secure]
# urllib3-install-pip

# jq-install-pm
RUN yum install -y jq && rm -rf /var/cache/yum
# jq-install-pm

# httplib2shim-install-pip
RUN pip3 install --no-cache-dir --upgrade httplib2shim
# httplib2shim-install-pip

# iptables-install-pm
RUN yum install -y iptables && rm -rf /var/cache/yum
# service_stop_disable iptables
# iptables-install-pm

# sshd-install-pm
RUN yum -y install openssh-server && rm -rf /var/cache/yum
RUN sudo bash -c "echo 'UseDNS no' >> /etc/ssh/sshd_config"
RUN sed -i 's/.*UseDNS.*/UseDNS no/g' /etc/ssh/sshd_config
RUN sed -i 's/.*GSSAPIAuthentication.*/GSSAPIAuthentication no/g' /etc/ssh/sshd_config
# sshd-install-pm

# novaclient-install-pip
RUN pip3 install --no-cache-dir --upgrade pbr
RUN pip3 install --no-cache-dir --upgrade netifaces
RUN pip3 install --no-cache-dir --upgrade python-novaclient==9.1.1
# novaclient-install-pip

# neutronclient-install-pip
RUN pip3 install --no-cache-dir --upgrade python-neutronclient==6.5.0
# neutronclient-install-pip

# cinderclient-install-pip
RUN pip3 install --no-cache-dir --upgrade python-cinderclient==3.2.0
# cinderclient-install-pip

# glanceclient-install-pip
RUN pip3 install --no-cache-dir --upgrade python-glanceclient==2.8.0
# glanceclient-install-pip

# softlayer-install-pip
RUN pip3 install --no-cache-dir --upgrade softlayer
# softlayer-install-pip

# boto-install-pip
RUN pip3 install --no-cache-dir --upgrade boto
# boto-install-pip

# libcloud-install-pip
RUN pip3 install --no-cache-dir --upgrade apache-libcloud
# libcloud-install-pip

# pygce-install-pip
RUN pip3 install --no-cache-dir --upgrade gcloud google-api-python-client
# pygce-install-pip

# docker-install-pip
RUN pip3 install --no-cache-dir --upgrade docker wget
# docker-install-pip

# pylxd-install-pip
RUN pip3 install --no-cache-dir --upgrade pylxd
# pylxd-install-pip

# pykube-ng-install-pip
RUN pip3 install --no-cache-dir --upgrade pykube-ng
# pykube-ng-install-pip

# R-install-pm
RUN yum install -y R && rm -rf /var/cache/yum
# R-install-pm

# rrdtool-install-pm
RUN yum install -y rrdtool && rm -rf /var/cache/yum
# rrdtool-install-pm

# python-rrdtool-install-pm
RUN yum install -y python3-rrdtool && rm -rf /var/cache/yum
# python-rrdtool-install-pm

# python-dateutil-install-pip
RUN pip3 install --no-cache-dir --upgrade python-dateutil
# python-dateutil-install-pip

# python-pillow-install-pip
RUN pip3 install --no-cache-dir --upgrade Pillow; /bin/true
# python-pillow-install-pip

# python-jsonschema-install-pip
RUN pip3 install --no-cache-dir --upgrade jsonschema
# python-jsonschema-install-pip

USER REPLACE_USERNAME
# gcloud-install-man
ENV CLOUDSDK_CORE_DISABLE_PROMPTS=1
RUN curl -f https://sdk.cloud.google.com | bash
RUN sudo ln -sf /home/REPLACE_USERNAME/google-cloud-sdk/bin/gcloud /usr/local/bin/gcloud
# gcloud-install-man

WORKDIR /home/REPLACE_USERNAME/

# gmetad-python-install-git
RUN mkdir -p /home/REPLACE_USERNAME/cbtool/3rd_party/workload
RUN cp____-f____/home/REPLACE_USERNAME/cbtool/util/manually_download_files.txt____/home/REPLACE_USERNAME/cbtool/3rd_party/workload; /bin/true
WORKDIR /home/REPLACE_USERNAME/cbtool/3rd_party
RUN git clone https://github.com/ibmcb/monitor-core.git
# gmetad-python-install-git

# pyhtml-install-git
WORKDIR /home/REPLACE_USERNAME/cbtool/3rd_party
RUN git clone https://github.com/ibmcb/HTML.py.git
WORKDIR /home/REPLACE_USERNAME/cbtool/3rd_party/HTML.py
RUN sudo python3 setup.py install
# pyhtml-install-git

# bootstrap-install-git
WORKDIR /home/REPLACE_USERNAME/cbtool/3rd_party
RUN git clone https://github.com/ibmcb/bootstrap.git
# bootstrap-install-git

# bootstrap-wizard-install-git
WORKDIR /home/REPLACE_USERNAME/cbtool/3rd_party
RUN git clone https://github.com/ibmcb/Bootstrap-Wizard.git
# bootstrap-wizard-install-git

# streamprox-install-git
WORKDIR /home/REPLACE_USERNAME/cbtool/3rd_party
RUN git clone https://github.com/ibmcb/StreamProx.git
# streamprox-install-git

# d3-install-git
WORKDIR /home/REPLACE_USERNAME/cbtool/3rd_party
RUN git clone https://github.com/ibmcb/d3.git
# d3-install-git

ADD installrlibs.R /usr/local/bin/installrlibs
RUN sudo chmod +x /usr/local/bin/installrlibs; sudo /usr/local/bin/installrlibs

USER root
RUN ssh-keygen -q -t rsa -N '' -f /root/.ssh/id_rsa; \
touch /root/.ssh/authorized_keys; \
chmod 644 /root/.ssh/authorized_keys; \
mkdir -p /home/REPLACE_USERNAME/.ssh/; \
echo "StrictHostKeyChecking no" > /root/.ssh/config; \
echo "UserKnownHostsFile=/dev/null" >> /root/.ssh/config; \
echo "HashKnownHosts no" >> /root/.ssh/config; \
rsync -a /root/.ssh/ /home/REPLACE_USERNAME/.ssh/; \
mkdir /home/REPLACE_USERNAME/repos; \
chown -R REPLACE_USERNAME:REPLACE_USERNAME /home/REPLACE_USERNAME/;

#
#

ARG CLOUDBENCH_VERSION=AUTO

ADD get_my_ips.sh /usr/local/bin/getmyips
ADD gucn.sh /usr/local/bin/gucn

WORKDIR /home/REPLACE_USERNAME/
RUN git clone https://github.com/ibmcb/cbtool.git cbtooltmp; \
cd /home/REPLACE_USERNAME/cbtooltmp; git checkout REPLACE_BRANCH; \
rsync -a /home/REPLACE_USERNAME/cbtooltmp/ /home/REPLACE_USERNAME/cbtool; \
rm -rf /home/REPLACE_USERNAME/cbtooltmp/; \
cp -f /home/REPLACE_USERNAME/cbtool/util/manually_download_files.txt /home/REPLACE_USERNAME/cbtool/3rd_party/workload; \
cd /home/REPLACE_USERNAME/cbtool; \
mv configs private_configs; \
mkdir configs; \
mkdir -p data; \
mv data private_data; \
mkdir data; \
sudo chmod +x /usr/local/bin/getmyips; \
sudo chmod +x /usr/local/bin/gucn;

#

#
#
#

#
#
#
#
#
#
#

RUN chown -R REPLACE_USERNAME:REPLACE_USERNAME /home/REPLACE_USERNAME/

USER REPLACE_USERNAME

WORKDIR /home/REPLACE_USERNAME/cbtool
