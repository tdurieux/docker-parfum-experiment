FROM registry.ci.openshift.org/openshift/release:golang-1.18

# OPERATOR_SDK should match the version of operator-sdk version in go.mod
ENV OPERATOR_SDK_VERSION=v1.21.0 \
    DELOREAN_VERSION=master \
    GOFLAGS=""

RUN set -o pipefail && \
    INSTALL_PKGS="skopeo rsync" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && rm -rf /var/cache/yum

# install delorean (from git with no history and only the tag)
# Note: Change to using pre-built binary when it's available https://issues.redhat.com/browse/DEL-288
RUN mkdir -p $GOPATH/src/github.com/delorean \
    && cd $GOPATH/src/github.com/delorean \
    && git clone --depth 1 -b $DELOREAN_VERSION https://github.com/integr8ly/delorean \
    && cd delorean \
    && make build/cli \
    && cp delorean /usr/local/bin

# install operator-sdk (from git with no history and only the tag)
RUN mkdir -p $GOPATH/src/github.com/operator-framework \
    && cd $GOPATH/src/github.com/operator-framework \
    && git clone --depth 1 -b $OPERATOR_SDK_VERSION https://github.com/operator-framework/operator-sdk \
    && cd operator-sdk \
    && go mod vendor \
    && make install \
    && chmod -R 0777 $GOPATH \
    && rm -rf $GOPATH/.cache

# install jq and yq
RUN wget -O jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 \
    && chmod +x ./jq \
    && cp jq /usr/bin \
    && curl -f -Lo /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v4.9.8/yq_linux_amd64 \
    && chmod +x /usr/local/bin/yq

# install nodejs
ENV NODE_VERSION=12.16.3 \
    NPM_CONFIG_CACHE=/tmp/.npm

RUN curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
    && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
    && rm "node-v$NODE_VERSION-linux-x64.tar.xz" \
    && ln -s /usr/local/bin/node /usr/local/bin/nodejs

# install chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm \
    && yum install -y --setopt=tsflags=nodocs ./google-chrome-stable_current_*.rpm && rm -rf /var/cache/yum

# install gosec
RUN curl -sfL https://raw.githubusercontent.com/securego/gosec/master/install.sh | sh -s -- -b $GOPATH/bin v2.11.0
