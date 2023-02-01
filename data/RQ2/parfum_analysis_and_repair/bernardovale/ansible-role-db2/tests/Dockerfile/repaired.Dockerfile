FROM bernardovale/ol7db2base:1.1

# Install Ansible and dependences
RUN curl -f https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -o epel-release-latest-7.noarch.rpm

RUN yum install -y epel-release-latest-7.noarch.rpm; rm -rf /var/cache/yum \
yum install -y glibc.i686 nspr; \
rm -rf epel-release-latest-7.noarch.rpm

RUN yum install -y unzip tar gcc python-devel python-pip openssl-devel file python-setuptools libffi-devel libselinux-python python2-crypto git sudo && rm -rf /var/cache/yum

RUN pip install --no-cache-dir ansible; \
pip install --no-cache-dir --upgrade setuptools; \
sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers; \
mkdir -p /etc/ansible/roles; \
echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

CMD ["/usr/sbin/init"]