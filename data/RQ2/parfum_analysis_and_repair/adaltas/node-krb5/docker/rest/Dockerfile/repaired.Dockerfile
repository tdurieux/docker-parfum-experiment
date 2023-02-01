FROM centos:7

# EPEL
RUN yum install -y epel-release && rm -rf /var/cache/yum

# Python 3
RUN yum update -y && yum install -y python3 python3-libs python3-devel python3-pip && rm -rf /var/cache/yum

# Install misc
RUN yum install -y wget git vim sudo gcc && rm -rf /var/cache/yum

# Install Kerberos
RUN yum install -y krb5-devel krb5-workstation && rm -rf /var/cache/yum

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir gssapi

RUN mkdir -p /node-krb5
COPY ./run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
