FROM centos:7

RUN yum -y install gcc-c++ make git libicu-devel rpmdevtools && rm -rf /var/cache/yum

# Add NodeSource repo
RUN curl -f --silent --location https://rpm.nodesource.com/setup_10.x | bash -

# Install development tools
RUN yum -y install nodejs && rm -rf /var/cache/yum

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
