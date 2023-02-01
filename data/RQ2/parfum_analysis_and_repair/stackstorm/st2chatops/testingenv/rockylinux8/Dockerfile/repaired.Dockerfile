FROM rockylinux:8

# Add NodeSource repo
RUN curl -f --silent --location https://rpm.nodesource.com/setup_10.x | bash -

# Install development tools
RUN yum -y install nodejs && rm -rf /var/cache/yum

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
