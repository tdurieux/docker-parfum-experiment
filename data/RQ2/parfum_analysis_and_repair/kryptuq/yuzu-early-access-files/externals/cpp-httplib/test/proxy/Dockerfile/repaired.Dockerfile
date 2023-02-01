FROM centos:7

ARG auth="basic"
ARG port="3128"

RUN yum install -y squid && rm -rf /var/cache/yum

COPY ./${auth}_squid.conf /etc/squid/squid.conf
COPY ./${auth}_passwd /etc/squid/passwd

EXPOSE ${port}

CMD ["/usr/sbin/squid", "-N"]
