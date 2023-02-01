FROM ubuntu:14.04

MAINTAINER ricoder "ricoder142@gmail.com"

ADD http://mirrors.163.com/.help/sources.list.trusty /etc/apt/sources.list

COPY conf/redis.conf /etc/redis/6379.conf
COPY conf/consul.json /etc/consul/consul.json
COPY supervisor/*.conf /etc/supervisor/conf.d/

RUN apt-get update && \
    apt-get -y --no-install-recommends install build-essential && \
    apt-get -y --no-install-recommends install openssh-server && \
    apt-get -y --no-install-recommends install libssl-dev && \
    apt-get -y --no-install-recommends install git && \
    apt-get -y --no-install-recommends install vim && \
    apt-get -y --no-install-recommends install wget && \
    apt-get -y --no-install-recommends install curl && \
    apt-get -y --no-install-recommends install unzip && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install supervisor && \
    apt-get -y --no-install-recommends install redis-server && \
    apt-get -y --no-install-recommends install mysql-server && \
    apt-get -y --no-install-recommends install mysql-client && \
    mkdir -p /data/services/consul-0.9/bin/ && \
    wget https://releases.hashicorp.com/consul/0.9.0/consul_0.9.0_linux_amd64.zip && \
    unzip consul_0.9.0_linux_amd64.zip && \
    mv ./consul /usr/local/bin/ && \
    mkdir /data/consul/ && \
    mkdir -p /data/logs/gologs/ && \
    mysql_install_db && \
    update-rc.d -f mysql defaults && \
    wget https://storage.googleapis.com/golang/go1.9.1.linux-amd64.tar.gz && \
    tar zxf go1.9.1.linux-amd64.tar.gz && \
    mkdir -p /data/goapp && \
    mv go/ /data/services/ && \
    rm -rf consul_0.9.0_linux_amd64.zip go1.9.1.linux-amd64.tar.gz && \
    echo "export GOROOT=/data/services/go\nPATH=$PATH:/data/services/go/bin" >> ~/.bashrc && rm -rf /var/lib/apt/lists/*;

EXPOSE 3306 8500 6379 8082 8083 8084 8085 5324 9999

CMD chown -R mysql:mysql /var/lib/mysql && \
    service mysql start && \
    supervisord -c /etc/supervisor/supervisord.conf -n