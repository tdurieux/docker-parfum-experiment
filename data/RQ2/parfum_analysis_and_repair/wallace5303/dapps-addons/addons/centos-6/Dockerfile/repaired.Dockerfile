FROM centos:6

RUN set -x \
  && yum install -y wget \
  && cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak \
  && wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-6.repo \
  && yum clean all \
  && yum makecache \
  && yum install -y epel-release \
  && yum install -y nginx && rm -rf /var/cache/yum

WORKDIR /home

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]