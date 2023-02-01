FROM opendevstackorg/ods-jenkins-agent-base-centos7:latest

LABEL maintainer="Erhard Wais <erhard.wais@boehringer-ingelheim.com>, Frank Joas <frank.joas@boehringer-ingelheim.com>, Josef Hartmann <josef.hartmann@boehringer-ingelheim.com>, Steve Taylor <steve.taylor@boehringer-ingelheim.com>"

# Labels consumed by Red Hat build service
LABEL com.redhat.component="jenkins-agent-terraform-rhel7-docker" \
      name="openshift3/jenkins-agent-terraform-rhel7" \
      version="0.1" \
      architecture="x86_64" \
      release="1" \
      io.k8s.display-name="Jenkins Agent AWS Terraform" \
      io.k8s.description="The jenkins Agent image has terraform and other tools on top of the jenkins agent base image." \
      io.openshift.tags="openshift,jenkins,agent,terraform,aws"

ENV TERRAFORM_VERSION 1.0.11
ENV TERRAFORM_CONFIG_INSPECT_VERSION 0.2.0
ENV TERRAFORM_DOCS_VERSION v0.16.0
ENV PYTHON_VERSION 3.9.11
ENV RUBY_VERSION 2.7.5
ENV PACKER_VERSION 1.7.10
ENV CONSUL_VERSION 1.11.2
ENV TFENV_VERSION 2.2.0
ENV NODEJS_VERSION 16.13.2
ENV BUNDLER_VERSION 2.2.23
ENV SOPS_VERSION=3.7.1
ENV AGE_VERSION=1.0.0
ENV GEM_HOME /opt/bundle
ENV RBENV_ROOT /opt/rbenv
ENV RBENV_SHELL bash

ENV INSTALL_PKGS="yum-utils gcc make git-core zlib zlib-devel gcc-c++ patch readline readline-devel \
    libffi-devel openssl-devel make bzip2 autoconf automake libtool bison curl sqlite-devel xz"
ENV PATH=/opt/tfenv/bin:/opt/rbenv/shims:/opt/rbenv/bin:/opt/node/bin:$PATH
ENV HOME=/home/jenkins

COPY python_requirements /tmp/requirements.txt

RUN set -x \
    && yum update -y \
    && yum upgrade -y \
    && yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS \
    && yum clean all \
    && rm -rf /var/cache/yum/* \
    && ls -lisa /home/jenkins

# Install PYTHON3
RUN cd /tmp \
    && curl -f -O https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz \
    && tar xzf Python-${PYTHON_VERSION}.tgz -C / \
    && rm -rf Python-${PYTHON_VERSION}.tgz

RUN cd /Python-${PYTHON_VERSION} \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make altinstall \
    && ln -s /Python-${PYTHON_VERSION}/python /usr/local/sbin/python3 \
    && python3 -V \
    && chmod a+rx /Python-${PYTHON_VERSION} \
    && chmod a+rx /Python-${PYTHON_VERSION}/python

RUN curl -f "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" \
    && python3 get-pip.py

# Upgrade PIP
RUN pip3 install --no-cache-dir --upgrade pip \
    && pip3 -V \
    && pip3 install --no-cache-dir virtualenv pycodestyle wheel

# Configure PIP SSL validation
RUN pip config set global.cert /etc/ssl/certs/ca-bundle.crt \
    && pip config list

# Install python requirements
RUN python3 -m pip install -r /tmp/requirements.txt

# Install awscli2
RUN curl -f -sS "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip -qq awscliv2.zip \
    && ./aws/install \
    && /usr/local/bin/aws --version \
    && rm -f awscliv2.zip \
    && rm -Rf ./aws

# Install awssamcli
RUN curl -f -L -sS "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip" -o "awssam.zip" \
    && unzip -qq -d awssam awssam.zip \
    && ./awssam/install && /usr/local/bin/sam --version && rm -f awssam.zip && rm -Rf ./awssam

# Install aws cdk
RUN wget -q "https://nodejs.org/dist/v${NODEJS_VERSION}/node-v${NODEJS_VERSION}-linux-x64.tar.xz" \
    && xzcat node-v${NODEJS_VERSION}-linux-x64.tar.xz | tar xpf - -C /opt/ \
    && mv /opt/node-v${NODEJS_VERSION}-linux-x64 /opt/node \
    && /opt/node/bin/npm install -g aws-cdk \
    && chown -R 1001:0 /opt/node && chmod +x /opt/node/bin/* \
    && node --version \
    && cdk --version

# Install Terraform
RUN wget -q -O /tmp/terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
    && unzip /tmp/terraform.zip -d /usr/local/bin \
    && rm -rf /tmp/terraform.zip \
    && terraform -h

# Install tfenv
RUN umask 0002 && cd /opt && git clone --branch v${TFENV_VERSION} https://github.com/tfutils/tfenv.git \
    && TFENV_CURL_OUTPUT=0 /opt/tfenv/bin/tfenv install ${TERRAFORM_VERSION} \
    && /opt/tfenv/bin/tfenv use ${TERRAFORM_VERSION} \
    && chown -R 1001:0 /opt/tfenv && chmod +x /opt/tfenv/bin/* \
    && terraform -version \
    && tfenv list

# Install Packer
RUN wget -q -O /tmp/packer.zip "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip" \
    && unzip /tmp/packer.zip -d /usr/local/bin \
    && rm -rf /tmp/packer.zip \
    && packer --version

# Install terraform-config-inspect
RUN wget -q -O /tmp/terraform-config-inspect.tar.gz https://github.com/nichtraunzer/terraform-config-inspect/releases/download/v${TERRAFORM_CONFIG_INSPECT_VERSION}/terraform-config-inspect_${TERRAFORM_CONFIG_INSPECT_VERSION}_linux_amd64.tar.gz \
    && tar zxpf /tmp/terraform-config-inspect.tar.gz -C /usr/local/bin/ \
    && rm -f /tmp/terraform-config-inspect.tar.gz \
    && chmod 755 /usr/local/bin/terraform-config-inspect

# Install Terraform Docs
RUN wget -q -O /tmp/terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/${TERRAFORM_DOCS_VERSION}/terraform-docs-${TERRAFORM_DOCS_VERSION}-linux-amd64.tar.gz \
    && tar zxpf /tmp/terraform-docs.tar.gz -C /usr/local/bin/ terraform-docs \
    && chmod +x /usr/local/bin/terraform-docs

# Install parallel
RUN wget -q -O /tmp/parallel-20160222-1.el7.noarch.rpm   https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/p/parallel-20160222-1.el7.noarch.rpm \
    && rpm -Uvh /tmp/parallel-20160222-1.el7.noarch.rpm \
    && yum install -y parallel \
    && yum clean all && rm -rf /var/cache/yum

#Install jq
RUN yum -y install https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-14.noarch.rpm \
    && yum install -y jq \
    && jq -Version \
    && yum clean all && rm -rf /var/cache/yum

#Install consul-cli
RUN wget -q "https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip" \
    && unzip consul_${CONSUL_VERSION}_linux_amd64.zip -d /usr/local/bin \
    && rm -f consul_${CONSUL_VERSION}_linux_amd64.zip \
    && chmod +x /usr/local/bin/consul && /usr/local/bin/consul -version

# Install mozilla/sops and AGE
RUN yum install -y https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops-${SOPS_VERSION}-1.x86_64.rpm \
    && wget -q -O /tmp/age.tar.gz https://github.com/FiloSottile/age/releases/download/v${AGE_VERSION}/age-v${AGE_VERSION}-linux-amd64.tar.gz \
    && tar xzf /tmp/age.tar.gz -C /usr/local/bin \
    && rm -f /tmp/age.tar.gz && rm -rf /var/cache/yum

RUN chown -R 1001:0 $HOME \
    && chmod -R g+rw $HOME \
    && mkdir -p $GEM_HOME \
    && chmod 2770 $GEM_HOME

COPY Gemfile Gemfile.lock $GEM_HOME/

RUN chown -R 1001:0 $GEM_HOME \
    && chmod -R g+rw $GEM_HOME \
    && ls -lisa /home/jenkins $GEM_HOME

RUN ls $JAVA_HOME/lib/security/cacerts \
    && chown 1001:0 $JAVA_HOME/lib/security/cacerts \
    && chmod g+w $JAVA_HOME/lib/security/cacerts

# setup ruby env and bundler gems
# RUBY https://syslint.com/blog/tutorial/how-to-install-ruby-on-rails-with-rbenv-on-centos-7-or-rhel-7/
RUN cd /opt \
    && umask 0002 \ 
    && git clone https://github.com/rbenv/rbenv.git /opt/rbenv \
    && echo 'export PATH="/opt/rbenv/shims:/opt/rbenv/bin:$PATH"' >> ~/.bash_profile \
    && echo 'eval "$(rbenv init -)"' >> ~/.bash_profile \
    && source ~/.bash_profile \
    && git clone https://github.com/rbenv/ruby-build.git /opt/rbenv/plugins/ruby-build \
    && echo 'export PATH="/opt/rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bash_profile \
    && source ~/.bash_profile \
    && rbenv install $RUBY_VERSION \
    && rbenv global $RUBY_VERSION \
    && gem install bundler -v $BUNDLER_VERSION \
    && RBENV_VERSION=$RUBY_VERSION gem install bundler -v $BUNDLER_VERSION \
    && bundle config default $BUNDLER_VERSION \
    && RBENV_VERSION=$RUBY_VERSION bundle config default $BUNDLER_VERSION \
    && bundle config set --global path $GEM_HOME \
    && RBENV_VERSION=$RUBY_VERSION bundle config set --global path $GEM_HOME \
    && cd $GEM_HOME \
    && BUNDLE_SILENCE_ROOT_WARNING=true bundle install --full-index --jobs=8 \
    && rm -Rf /home/jenkins/.bundle/cache

USER 1001

