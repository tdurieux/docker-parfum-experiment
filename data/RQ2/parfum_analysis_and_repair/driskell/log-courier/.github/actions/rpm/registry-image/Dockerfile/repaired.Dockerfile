FROM centos:7
RUN yum -y install rpm-sign rpm-build epel-release ca-certificates centos-release-scl && rm -rf /var/cache/yum
RUN yum -y install copr-cli golang rh-git218 && rm -rf /var/cache/yum
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
