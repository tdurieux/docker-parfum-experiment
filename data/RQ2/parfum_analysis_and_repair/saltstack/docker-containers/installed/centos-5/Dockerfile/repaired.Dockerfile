from saltstack/centos-5-minimal
MAINTAINER SaltStack, Inc.

# Update Current Image and install dependencies
RUN yum update -y && yum install -y --enablerepo=epel curl && rm -rf /var/cache/yum

# Install Latest Salt from the Develop Branch
RUN curl -f -L https://bootstrap.saltstack.com | sh -s -- -X git develop
