FROM centos:8

RUN yum update -y --skip-broken && yum install --skip-broken -y wget zlib zip unzip libcurl && rm -rf /var/cache/yum

ADD megadepth_statlib /megadepth
RUN chmod a+x /megadepth

ENTRYPOINT ["/megadepth"]
