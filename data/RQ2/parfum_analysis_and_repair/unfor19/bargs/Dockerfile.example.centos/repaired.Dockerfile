FROM centos:centos8
RUN yum update -y && yum install -y bash util-linux && rm -rf /var/cache/yum
WORKDIR /code
COPY . .
ENV LANG "en_US.UTF-8"
ENTRYPOINT [ "bash", "example.sh" ]
