FROM centos:7

RUN set -x  \
    && yum -y install \
       epel-release \
    && yum -y install \
       createrepo \
       python-pip && rm -rf /var/cache/yum

RUN set -x \
    && pip install --no-cache-dir \
       boto3


COPY *.py /mkrepo/
