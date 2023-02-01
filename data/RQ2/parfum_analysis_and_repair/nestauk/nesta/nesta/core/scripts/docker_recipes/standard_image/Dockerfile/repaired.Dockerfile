FROM amazonlinux:latest

# Install common dependencies
RUN rm -rf /var/cache/yum/x86_64/latest
RUN yum update -y
RUN yum install sudo -y && rm -rf /var/cache/yum
RUN yum install aws-cli -y && rm -rf /var/cache/yum
RUN yum install zip -y && rm -rf /var/cache/yum
RUN yum install unzip -y && rm -rf /var/cache/yum
RUN yum -y install findutils && rm -rf /var/cache/yum

RUN yum install python -y && rm -rf /var/cache/yum
RUN yum install python3 -y && rm -rf /var/cache/yum

ADD launch.sh /usr/local/bin/launch.sh
WORKDIR /tmp
USER root

ENTRYPOINT ["/usr/local/bin/launch.sh"]
