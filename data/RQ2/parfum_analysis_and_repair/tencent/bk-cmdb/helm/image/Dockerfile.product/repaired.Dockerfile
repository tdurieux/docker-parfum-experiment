FROM centos:7

# copy to bin directory
RUN mkdir -p /data/bin/
COPY bk-cmdb /data/bin/bk-cmdb/