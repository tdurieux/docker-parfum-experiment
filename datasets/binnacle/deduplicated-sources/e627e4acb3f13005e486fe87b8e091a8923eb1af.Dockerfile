FROM centos:7

# Add NodeSource repo
RUN curl --silent --location https://rpm.nodesource.com/setup_10.x | bash -

# Install development tools
RUN yum -y install nodejs

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
