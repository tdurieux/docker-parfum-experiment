FROM codercom/enterprise-base:centos

# Run everything as root
USER root

# Install whichever Node version is LTS
RUN curl -f -sL https://rpm.nodesource.com/setup_lts.x | bash -
RUN yum install -y nodejs && rm -rf /var/cache/yum

# Install Yarn
RUN curl -f --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo
RUN yum install -y yarn && rm -rf /var/cache/yum

# Set back to coder user
USER coder
