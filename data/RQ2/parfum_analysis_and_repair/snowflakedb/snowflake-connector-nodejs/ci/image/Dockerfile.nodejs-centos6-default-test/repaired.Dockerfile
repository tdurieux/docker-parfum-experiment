FROM centos:6.10

# update OS
RUN yum -y update
RUN yum -y install epel-release && rm -rf /var/cache/yum
RUN yum -y install centos-release-scl && rm -rf /var/cache/yum

# nvm environment variables
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 10.0.0

# node
RUN mkdir -p $NVM_DIR
RUN curl -f -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash

RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
COPY scripts/npmrc /root/.npmrc
RUN npm install npm@latest -g && npm cache clean --force;

# python
RUN yum -y install rh-python36 && rm -rf /var/cache/yum
COPY scripts/python3.6.sh /usr/local/bin/python3.6
COPY scripts/python3.6.sh /usr/local/bin/python3
RUN chmod a+x /usr/local/bin/python3.6
RUN chmod a+x /usr/local/bin/python3
COPY scripts/pip.sh /usr/local/bin/pip
RUN chmod a+x /usr/local/bin/pip
RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir -U snowflake-connector-python

# aws
RUN pip install --no-cache-dir -U awscli
COPY scripts/aws.sh /usr/local/bin/aws
RUN chmod a+x /usr/local/bin/aws

# Development tools
RUN yum -y groupinstall "Development Tools" && \
    yum -y install zlib-devel && rm -rf /var/cache/yum

# git
RUN curl -f -o - https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.26.0.tar.gz | tar xfz - && \
    cd git-2.26.0 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/opt/git && make && make install && \
    ln -s /opt/git/bin/git /usr/local/bin/git

# zstd
RUN yum -y install zstd && rm -rf /var/cache/yum

# jq
RUN yum -y install jq && rm -rf /var/cache/yum

# gosu
RUN curl -f -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.11/gosu-amd64"
RUN chmod +x /usr/local/bin/gosu
COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# workspace

RUN mkdir -p /home/user
RUN chmod 777 /home/user
WORKDIR /home/user

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
