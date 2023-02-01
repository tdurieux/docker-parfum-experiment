# upstream https://github.com/CentOS/sig-cloud-instance-build
FROM centos:8

MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \ 
    TERM="xterm" \
    LANG="en_US.UTF-8" \ 
    LANGUAGE="en_US.UTF-8" \
    #LC_ALL="en_US.UTF-8" \
    TZ="Asia/Shanghai"

COPY yum.repos.d/*.repo /etc/yum.repos.d/

# set timezone