FROM centos:centos7
LABEL description="descheduler"

COPY ./bin/descheduler descheduler

CMD ["/descheduler", "--help"]