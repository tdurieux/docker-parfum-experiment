FROM centos:latest

RUN yum -y install vim && rm -rf /var/cache/yum
RUN mkdir -p /src

# COPY Pine /src
# COPY  /src
# COPY server.conf /src
COPY . /src

WORKDIR /src

EXPOSE 9996