FROM amazon/aws-cli
RUN yum update -y && yum install wget tar gzip -y && rm -rf /var/cache/yum
