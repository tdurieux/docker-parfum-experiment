FROM centos:7
MAINTAINER Pavel Studenik <pstudeni@redhat.com>

RUN URL_SW=http://yum.spacewalkproject.org/2.7/RHEL/7/x86_64/ && \
    rpm -Uvh $URL_SW/$( curl -f --silent $URL_SW | grep spacewalk-repo-[0-9] | grep -Po '(?<=href=")[^"]*') && \
    rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    sed '/enabled=/a exclude=c3p0*' -i  /etc/yum.repos.d/epel*.repo && \
    yum install yum-utils -y && yum-config-manager repo --enable epel-testing && rm -rf /var/cache/yum

ADD copr-java-packages.repo /etc/yum.repos.d/copr-java-packages.repo

RUN yum install -y spacewalk-postgresql syslinux \
                   spacewalk-taskomatic spacewalk-common && \
    yum clean all && rm -rf /var/cache/yum

ADD answer.txt /root/answer.txt
ADD bin/docker-spacewalk-setup.sh /root/docker-spacewalk-setup.sh
ADD bin/docker-spacewalk-run.sh /root/docker-spacewalk-run.sh
ADD bin/spacewalk-hostname-rename.sh /root/spacewalk-hostname-rename.sh

RUN chmod a+x /root/docker-spacewalk-{run,setup}.sh

EXPOSE 69 80 443 5222

CMD /root/docker-spacewalk-run.sh

