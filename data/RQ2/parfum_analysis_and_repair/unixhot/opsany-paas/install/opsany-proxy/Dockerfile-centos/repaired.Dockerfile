# Base Image
FROM centos:7.9.2009

# Add Proxy
ADD opsany-proxy /opt/opsany-proxy

# Install Pkg

RUN curl -f -o /etc/yum.repos.d/epel.repo https://mirrors.aliyun.com/repo/epel-7.repo && \
    yum install -y kde-l10n-Chinese glibc-common sshpass nginx supervisor gcc glibc make zlib-devel openssl-devel curl-devel mysql-devel python36 python36-devel openssh-clients openssl-devel && \
    mkdir -p /opt/opsany/logs && \
    yum clean all && \
    useradd -M saltapi && \
    echo "saltapi:OpsAny@2020" | chpasswd && \
    echo -e "LANG=zh_CN.UTF-8" > /etc/locale.conf && \
    echo -e 'export LANG="zh_CN.UTF-8"' >> /etc/profile && \
    localedef -c -f UTF-8 -i zh_CN zh_CN.utf8 && source /etc/profile && rm -rf /var/cache/yum

ENV LC_ALL zh_CN.UTF-8

# Pip Install

RUN pip3 --no-cache-dir install --upgrade pip -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com && \
    pip3 --no-cache-dir install CherryPy==18.6.1 jinja2==3.0.0 salt==3004.1 -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com  && \
    pip3 --no-cache-dir install -r /opt/opsany-proxy/requirements.txt -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com

# Supervisord config
ADD nginx.conf /etc/nginx/nginx.conf
ADD supervisord.conf /etc/supervisord.conf
ADD saltmaster.ini /etc/supervisord.d/saltmaster.ini
ADD saltapi.ini /etc/supervisord.d/saltapi.ini
ADD proxy.ini /etc/supervisord.d/proxy.ini
ADD nginx.ini /etc/supervisord.d/nginx.ini

# Outside Port
EXPOSE 4505 4506 8010

# Supervisord start
CMD ["supervisord", "-c", "/etc/supervisord.conf"]
