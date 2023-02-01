FROM amazon/aws-sam-cli-build-image-ruby2.7

# Ensure minimum required SAM version.
ENV SAM_CLI_VERSION=1.23.0
RUN curl -f -L "https://github.com/aws/aws-sam-cli/releases/download/v${SAM_CLI_VERSION}/aws-sam-cli-linux-x86_64.zip" \
         -o "aws-sam-cli-linux-x86_64.zip" && \
    unzip -q aws-sam-cli-linux-x86_64.zip -d sam-installation && \
    ./sam-installation/install && \
    rm -rf ./sam-installation ./aws-sam-cli-linux-x86_64.zip

# Node for JavaScript.
RUN curl -f -sL https://rpm.nodesource.com/setup_14.x | bash - && \
    yum install -y nodejs && \
    curl -f --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo && \
    rpm --import https://dl.yarnpkg.com/rpm/pubkey.gpg && \
    yum install -y yarn && rm -rf /var/cache/yum

WORKDIR /var/task
