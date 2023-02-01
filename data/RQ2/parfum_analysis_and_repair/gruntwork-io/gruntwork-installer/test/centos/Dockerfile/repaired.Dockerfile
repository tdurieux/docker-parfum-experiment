FROM centos:7
MAINTAINER Gruntwork <info@gruntwork.io>

RUN yum install -y curl sudo && rm -rf /var/cache/yum

COPY . /test

CMD ["echo", "This container is used for testing. Consider running one of the test scripts under the /test folder."]
