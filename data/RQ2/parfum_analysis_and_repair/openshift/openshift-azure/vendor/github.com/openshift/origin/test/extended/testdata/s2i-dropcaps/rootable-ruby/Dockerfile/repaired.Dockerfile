FROM centos/ruby-25-centos7:latest
USER root
RUN yum -y install expect && rm -rf /var/cache/yum
RUN echo "root:redhat" | chpasswd
USER 1001
COPY ./adduser /usr/libexec/s2i/
COPY ./assemble /usr/libexec/s2i/
