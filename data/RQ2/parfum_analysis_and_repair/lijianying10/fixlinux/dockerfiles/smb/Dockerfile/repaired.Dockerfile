FROM ubuntu:14.04

RUN sed -i 's/archive.ubuntu/mirrors.aliyun/g' /etc/apt/sources.list && apt-get update && apt-get install --no-install-recommends -y samba smbfs && rm -rf /var/lib/apt/lists/*;
CMD ['/bin/bash']
