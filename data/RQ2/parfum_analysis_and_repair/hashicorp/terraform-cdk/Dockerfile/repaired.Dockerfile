FROM docker.mirror.hashicorp.services/jsii/superchain:node14

ARG DEFAULT_TERRAFORM_VERSION
ARG AVAILABLE_TERRAFORM_VERSIONS

RUN yum install -y unzip jq gcc gcc-c++ && curl -f https://raw.githubusercontent.com/pypa/pipenv/master/get-pipenv.py | python3 && rm -rf /var/cache/yum
RUN npm install -g @sentry/cli --unsafe-perm && npm cache clean --force;

ENV TF_PLUGIN_CACHE_DIR="/root/.terraform.d/plugin-cache"           \
    # MAVEN_OPTS is set in jsii/superchain with -Xmx512m. This isn't enough memory for provider generation.
    MAVEN_OPTS="-Xms256m -Xmx3G"

# Install Terraform
RUN for VERSION in ${AVAILABLE_TERRAFORM_VERSIONS}; do curl -f -LOk https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip && \
    mkdir -p /usr/local/bin/tf/versions/${VERSION} && \
    unzip terraform_${VERSION}_linux_amd64.zip -d /usr/local/bin/tf/versions/${VERSION} && \
    ln -s /usr/local/bin/tf/versions/${VERSION}/terraform /usr/local/bin/terraform${VERSION}; rm terraform_${VERSION}_linux_amd64.zip;done && \
    ln -s /usr/local/bin/tf/versions/${DEFAULT_TERRAFORM_VERSION}/terraform /usr/local/bin/terraform
