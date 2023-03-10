FROM centos:6.7
MAINTAINER Jeremy Dyer <jdye64@gmail.com>

# Install system dependencies
RUN yum install -y unzip git vim wget tar postgresql-jdbc* && rm -rf /var/cache/yum

# Install HDF 2.0.0.0
RUN wget -nv https://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.4.0.1/ambari.repo -O /etc/yum.repos.d/ambari.repo

#Update the YUM repo
RUN yum update -y

# Exposes the needed baseline ports
EXPOSE 8080
EXPOSE 9090

# Cleanup to reduce the overall size of the image
RUN yum clean all