FROM centos:7

RUN yum install -y epel-release && rm -rf /var/cache/yum

# Install bzip2
RUN yum install -y bzip2 && rm -rf /var/cache/yum

RUN yum install -y git && rm -rf /var/cache/yum

# Install nodejs 8
RUN curl -f -sL https://rpm.nodesource.com/setup_12.x | bash -
RUN yum install -y nodejs && rm -rf /var/cache/yum

# RUN ln -s /usr/bin/nodejs /usr/bin/node

# Install tty-table
RUN git clone https://www.github.com/tecfu/tty-table

# Install dev dependencies
WORKDIR /tty-table
RUN npm install && npm cache clean --force;

# Run unit tests
RUN npx mocha
