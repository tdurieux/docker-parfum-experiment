FROM fedora:26

RUN dnf update -y && dnf install -y python python-pip && \
 pip install --no-cache-dir --upgrade pip && \
 pip install --no-cache-dir django django-bootstrap3 pyexcelerator pyral tzlocal requests2 lxml suds-jurko python-memcached

