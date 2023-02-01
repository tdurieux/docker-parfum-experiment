FROM centos:7 AS base
RUN curl -f -o /etc/yum.repos.d/epel-7.repo https://mirrors.aliyun.com/repo/epel-7.repo && \
        yum install -y bind-utils xfsprogs jq fuse && rm -rf /var/cache/yum
RUN mkdir -p /cfs/bin /cfs/conf /cfs/logs /cfs/data

FROM base AS server
COPY build/bin/cfs-server /cfs/bin/

FROM base AS client
COPY build/bin/cfs-client /cfs/bin/

