FROM fedora:latest

RUN yum install -y nmap-ncat && rm -rf /var/cache/yum

EXPOSE 2222

CMD ["/usr/bin/ncat", "-l", "2222", "-k", "-c", "/usr/bin/date"]

