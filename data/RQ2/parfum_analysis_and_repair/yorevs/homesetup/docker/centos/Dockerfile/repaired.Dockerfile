FROM centos

MAINTAINER yorevs

RUN yum install -y curl sudo glibc-common && rm -rf /var/cache/yum
RUN curl -f -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash
RUN echo "Type 'reload' to activate HomeSetup"
CMD ["bash", "--login"]
