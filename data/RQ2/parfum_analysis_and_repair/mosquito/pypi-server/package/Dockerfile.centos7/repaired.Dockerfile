FROM mosquito/fpm:centos7

RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum install -y python-pip python-devel make gcc && rm -rf /var/cache/yum
RUN pip install --no-cache-dir -U pip virtualenv sh plumbum
RUN yum install -y \
    libcurl-devel \
    libcurl-openssl-devel \
    libffi-devel \
    libpqxx-devel \
    libxml2-devel \
    libxslt-devel \
    mariadb-devel \
    openssl-devel \
    postgresql-devel && rm -rf /var/cache/yum

ENV PYCURL_SSL_LIBRARY=openssl