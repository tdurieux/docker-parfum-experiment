FROM centos:7
LABEL maintainer="dev@cloudesire.com"

ENV OS_RELEASE=train

RUN yum clean all \
  && yum -y update \
  && yum -y install centos-release-openstack-${OS_RELEASE} \
  && yum -y install openstack-keystone openstack-utils python-openstackclient \
  && yum clean all && rm -rf /var/cache/yum

COPY start_keystone.sh /
EXPOSE 5000 35357

CMD ["/start_keystone.sh"]
