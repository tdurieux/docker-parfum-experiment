FROM centos:8 as build-tools
LABEL maintainer "pipelines-dev <pipelines-dev@redhat.com>"
LABEL author "Konrad Kleine <kkleine@redhat.com>"
ENV LANG=en_US.utf8
ENV GOPATH /tmp/go
ARG GO_PACKAGE_PATH=github.com/openshift/tektoncd-pipeline-operator

ENV GIT_COMMITTER_NAME pipelines-dev
ENV GIT_COMMITTER_EMAIL pipelines-dev@redhat.com

RUN yum install epel-release -y && rm -rf /var/cache/yum

RUN yum install -y  \
    findutils \
    git \
    make \
    procps-ng \
    tar \
    wget \
    which \
    bc \
    yamllint \
    python3-virtualenv \
    cpp \
    gcc \
    kernel-headers \
    openssl-devel \
    libxcrypt-devel \
    glibc-devel \
    && yum clean all && rm -rf /var/cache/yum

RUN wget https://dl.google.com/go/go1.13.4.linux-amd64.tar.gz; \
    tar -C /usr/local -xzf go1.13.4.linux-amd64.tar.gz && rm go1.13.4.linux-amd64.tar.gz

ENV PATH=$PATH:/usr/local/go/bin

# install dep
RUN mkdir -p $GOPATH/bin && chmod a+rwx $GOPATH \
    && curl -f -L -s https://github.com/golang/dep/releases/download/v0.5.4/dep-linux-amd64 -o dep \
    && echo "40a78c13753f482208d3f4bea51244ca60a914341050c588dad1f00b1acc116c  dep" > dep-linux-amd64.sha256 \
    && sha256sum -c dep-linux-amd64.sha256 \
    && rm dep-linux-amd64.sha256 \
    && chmod +x ./dep \
    && mv dep $GOPATH/bin/dep

ENV PATH=$PATH:$GOPATH/bin

# download, verify and install openshift client tools (oc and kubectl)
WORKDIR /tmp
RUN OPENSHIFT_CLIENT_VERSION=$( curl -f -s https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/release.txt | sed -n '/Version:/ { s/[ ]*Version:[ ]*// ;p}') \
    && curl -f -L -O -s https://mirror.openshift.com/pub/openshift-v4/clients/ocp/$OPENSHIFT_CLIENT_VERSION/openshift-client-linux-$OPENSHIFT_CLIENT_VERSION.tar.gz \
    && curl -f -L -s https://mirror.openshift.com/pub/openshift-v4/clients/ocp/$OPENSHIFT_CLIENT_VERSION/sha256sum.txt | \
       grep openshift-client-linux-$OPENSHIFT_CLIENT_VERSION.tar.gz > openshift-origin-client-tools.sha256 \
    && sha256sum -c openshift-origin-client-tools.sha256 \
    && mkdir openshift-origin-client-tools \
    && tar xzf openshift-client-linux-$OPENSHIFT_CLIENT_VERSION.tar.gz --directory openshift-origin-client-tools \
    && mv /tmp/openshift-origin-client-tools/oc /usr/bin/oc \
    && mv /tmp/openshift-origin-client-tools/kubectl /usr/bin/kubectl \
    && rm -rf ./openshift* \
    && oc version && rm openshift-client-linux-$OPENSHIFT_CLIENT_VERSION.tar.gz

# install operator-sdk (from git with no history and only the tag)
RUN mkdir -p $GOPATH/src/github.com/operator-framework \
    && cd $GOPATH/src/github.com/operator-framework \
    && git clone --depth 1 -b v0.17.2 https://github.com/operator-framework/operator-sdk \
    && cd operator-sdk \
    && GO111MODULE=on make install

RUN mkdir -p ${GOPATH}/src/${GO_PACKAGE_PATH}/

WORKDIR ${GOPATH}/src/${GO_PACKAGE_PATH}

ENTRYPOINT [ "/bin/bash" ]
