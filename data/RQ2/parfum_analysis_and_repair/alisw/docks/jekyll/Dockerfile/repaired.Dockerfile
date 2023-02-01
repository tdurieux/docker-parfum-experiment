FROM centos:centos7

RUN yum update -y && yum install -y ruby ruby-devel rubygems && rm -rf /var/cache/yum
RUN yum update -y && yum install -y make gcc && rm -rf /var/cache/yum
RUN gem install jekyll
RUN yum update -y && yum install -y http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm && rm -rf /var/cache/yum
RUN yum install -y nodejs git java-1.8.0-openjdk python-pip vim unzip jq && rm -rf /var/cache/yum

ADD https://releases.hashicorp.com/vault/0.5.0/vault_0.5.0_linux_amd64.zip vault.zip
RUN unzip vault.zip && mv ./vault /usr/bin/vault

RUN pip install --no-cache-dir elasticsearch elasticsearch-dsl PyYAML
