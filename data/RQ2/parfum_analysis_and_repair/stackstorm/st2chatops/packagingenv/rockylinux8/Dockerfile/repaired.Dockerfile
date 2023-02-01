FROM rockylinux:8

RUN yum -y install gcc-c++ make git libicu-devel rpmdevtools && rm -rf /var/cache/yum

# Add NodeSource repo
RUN curl -f --silent --location https://rpm.nodesource.com/setup_10.x | bash -

# Install development tools
RUN yum -y module install nodejs:10

# Install python3 for gyp
RUN yum -y install python3 && rm -rf /var/cache/yum

# Upgrade gyp to a python3 compatible version
RUN npm install -g node-gyp@latest && npm cache clean --force;

# Install development tools
RUN yum -y install nodejs && rm -rf /var/cache/yum

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
