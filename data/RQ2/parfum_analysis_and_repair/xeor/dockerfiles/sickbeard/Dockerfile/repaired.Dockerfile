FROM xeor/base-centos-daemon

MAINTAINER Lars Solberg <lars.solberg@gmail.com>
ENV REFRESHED_AT 2014-10-11

RUN yum install -y tar python-cheetah && \
    curl -f -L https://github.com/midgetspy/Sick-Beard/tarball/master > sickbeard.tgz && \
    tar -zxvf sickbeard.tgz && mv midgetspy-Sick-Beard* /sickbeard && rm -rf /var/cache/yum

COPY init/ /init/
COPY supervisord.d/ /etc/supervisord.d/
