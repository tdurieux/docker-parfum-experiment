# This docker file was used to produce the docker image used to build the
# RPMs for the servers.

FROM centos:6

MAINTAINER weston_schmidt@alumni.purdue.edu

RUN yum update -y
RUN yum install -y rpm-build rpmdevtools && rpmdev-setuptree && rm -rf /var/cache/yum
RUN rpm --import https://mirror.go-repo.io/centos/RPM-GPG-KEY-GO-REPO
RUN curl -f -s https://mirror.go-repo.io/centos/go-repo.repo | tee /etc/yum.repos.d/go-repo.repo
RUN yum install -y golang git && rm -rf /var/cache/yum
RUN yum clean all
RUN mkdir -p /gopath/bin
ENV GOPATH /gopath
ENV GOBIN /gopath/bin
ENV PATH $PATH:$GOBIN
RUN curl -f https://glide.sh/get | sh
RUN yum update -y
