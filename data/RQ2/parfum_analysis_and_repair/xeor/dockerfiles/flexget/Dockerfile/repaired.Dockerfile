FROM xeor/base-centos-daemon

MAINTAINER Lars Solberg <lars.solberg@gmail.com>
ENV REFRESHED_AT 2015-01-07

RUN yum install -y inotify-tools && pip install --no-cache-dir flexget && rm -rf /var/cache/yum

COPY init/ /init/
COPY supervisord.d/ /etc/supervisord.d/

ENV PYTHONIOENCODING utf-8
