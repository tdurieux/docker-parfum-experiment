FROM centos:latest
RUN yum install -y bash zsh ksh && rm -rf /var/cache/yum
WORKDIR /app
COPY . /app
