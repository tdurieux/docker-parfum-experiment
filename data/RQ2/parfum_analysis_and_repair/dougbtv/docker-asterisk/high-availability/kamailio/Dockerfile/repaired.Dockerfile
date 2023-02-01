FROM centos:centos7
MAINTAINER Doug Smith <info@laboratoryb.org>
ENV build_date 2014-12-05 001

# -------------------- Yum installs
RUN yum update -y
RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum install -y nano wget inotify-tools rsyslog && rm -rf /var/cache/yum
RUN wget -O /etc/yum.repos.d/kamailio.repo https://download.opensuse.org/repositories/home:/kamailio:/v4.4.x-rpms/CentOS_7/home:kamailio:v4.4.x-rpms.repo
RUN yum install -y kamailio && rm -rf /var/cache/yum

# -------------------- Kamailio configs

RUN echo "local0.*                        -/var/log/kamailio.log" >> /etc/rsyslog.conf

COPY run.sh /run.sh
COPY dispatcher_watch.sh /
COPY kamailio.cfg /etc/kamailio/kamailio.cfg
COPY dispatcher.list /etc/kamailio/dispatcher.list

CMD /run.sh
