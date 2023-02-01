FROM amazon/aws-cli:2.7.2

# Move files in for deployment & cleanup
COPY deploy.sh /deploy.sh
COPY cleanup.sh /cleanup.sh

# Get tools needed for packaging
RUN yum update -y \
  && yum install -y zip unzip jq \
  && yum clean all
