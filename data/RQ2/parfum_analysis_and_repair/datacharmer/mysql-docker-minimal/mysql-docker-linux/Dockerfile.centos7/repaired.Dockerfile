FROM centos:7

MAINTAINER Giuseppe Maxia <gmax@cpan.org>

RUN yum install -y libaio numactl-libs perl which bash-completion \
    && export USER=root \
    && export HOME=/root && rm -rf /var/cache/yum

EXPOSE 3306
COPY dbdeployer /usr/bin/dbdeployer
COPY dbdeployer_completion.sh /etc/bash_completion.d/
COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
