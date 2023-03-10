FROM replaced-by-buildconfig
# Serves as a standard build environment for OpenShift builds. It is based on the
# ART golang builder and has packages layered on top of support CI only use cases
# (e.g. compiling test cases) that simply don't occur downstream.
# Used as a template for 'images:streams gen-buildconfigs'

# Install protobuf-3.0.0 (used by upstream k8s) for CI only testing
# Context: https://coreos.slack.com/archives/CB95J6R4N/p1600340218406400
ENV PATH=/opt/google/protobuf/bin:$PATH
RUN set -euxo pipefail && \
    f=$( mktemp ) && \
    curl --fail -L https://mirror.openshift.com/pub/openshift-static-ci-deps/protobuf-3.0.0/protoc-3.0.0-linux-x86_64.zip > "${f}" && \
    mkdir -p /opt/google/protobuf && \
    unzip "${f}" -d /opt/google/protobuf && \
    curl --fail -L https://github.com/coreos/etcd/releases/download/v3.4.13/etcd-v3.4.13-linux-amd64.tar.gz | tar -f - -xz --no-same-owner -C /usr/local/bin --strip-components=1 etcd-v3.4.13-linux-amd64/etcd

# Install common CI tools and epel for packages like tito.
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    INSTALL_PKGS="bc procps-ng util-linux bind-utils bsdtar createrepo_c device-mapper device-mapper-persistent-data e2fsprogs ethtool file findutils gcc git glib2-devel gpgme gpgme-devel hostname iptables jq krb5-devel libassuan libassuan-devel libseccomp-devel libvirt-devel lsof make mercurial nmap-ncat openssl rsync socat systemd-devel tar tito tree wget which xfsprogs zip goversioninfo gettext python3 iproute" && \
    yum install -y $INSTALL_PKGS && \
    alternatives --set python /usr/bin/python3 && \
    yum clean all && \
    touch /os-build-image && \
    git config --system user.name origin-release-container && \
    git config --system user.email origin-release@redhat.com && rm -rf /var/cache/yum

# Install common go tools upstream devs are expecting in CI.
# Pure cargo culting from https://github.com/openshift/release/blob/51d92eb6a6d730e932a5daf68829ca7936739904/projects/origin-release/golang-1.13/Dockerfile#L41
# Clear GOFLAGS temporarily for 1.12  bug:https://github.com/golang/go/issues/32502
RUN GOFLAGS='' go get golang.org/x/tools/cmd/cover \
        github.com/Masterminds/glide \
        golang.org/x/tools/cmd/goimports \
        github.com/tools/godep \
        golang.org/x/lint/golint \
        gotest.tools/gotestsum \
        github.com/openshift/release/tools/gotest2junit \
        github.com/openshift/imagebuilder/cmd/imagebuilder && \
    GOFLAGS='' GO111MODULE=on go get gotest.tools/gotestsum@v0.5.2 && \
    mv $GOPATH/bin/* /usr/bin/ && \
    rm -rf $GOPATH/* $GOPATH/.cache && \
    mkdir $GOPATH/bin && \
    mkdir -p /go/src/github.com/openshift/origin && \
    ln -s /usr/bin/imagebuilder $GOPATH/bin/imagebuilder && \
    ln -s /usr/bin/goimports $GOPATH/bin/goimports && \
    curl --fail -L https://github.com/golang/dep/releases/download/v0.5.4/dep-linux-amd64 > /usr/bin/dep && \
    chmod +x /usr/bin/dep

# make go related directories writeable since builds in CI will run as non-root.
RUN mkdir -p $GOPATH && \
    chmod g+xw -R $GOPATH && \
    chmod g+xw -R $(go env GOROOT)

# Assert packages in separate RUN block so we are sure env variables are set up correctly
RUN set -euxo pipefail && \
    command -v protoc && protoc --version && [ "$( protoc --version )" = "libprotoc 3.0.0" ] && \
    command -v etcd && etcd --version && [ "$( etcd --version | head -n1 )" = "etcd Version: 3.4.13" ]

# Some image building tools don't create a missing WORKDIR
RUN mkdir -p /go/src/github.com/openshift/origin
WORKDIR /go/src/github.com/openshift/origin
