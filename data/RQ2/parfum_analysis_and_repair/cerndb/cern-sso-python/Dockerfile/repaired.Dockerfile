FROM cern/slc6-base
RUN yum update -y
RUN yum install -y python2-devel && rm -rf /var/cache/yum
RUN yum install -y python-setuptools python-requests python-requests-kerberos python-six && rm -rf /var/cache/yum
RUN yum install -y pytest && rm -rf /var/cache/yum
RUN yum install -y libxml2-devel python-lxml && rm -rf /var/cache/yum
RUN yum install -y gcc make && rm -rf /var/cache/yum
RUN mkdir /var/workdir
RUN mkdir /home/work
COPY . /var/workdir
WORKDIR /home/work
