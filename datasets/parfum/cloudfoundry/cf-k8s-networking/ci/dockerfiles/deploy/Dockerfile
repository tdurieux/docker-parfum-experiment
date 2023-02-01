FROM cloudfoundry/cf-deployment-concourse-tasks
MAINTAINER https://github.com/cloudfoundry/cf-k8s-networking

ENV HELM_VERSION 2.12.3
ENV KAPP_VERSION "v0.33.0"
ENV KAPP_CHECKSUM "2a3328c9eca9f43fe639afb524501d9d119feeea52c8a913639cfb96e38e93d1"
ENV YTT_VERSION "v0.30.0"
ENV YTT_CHECKSUM "456e58c70aef5cd4946d29ed106c2b2acbb4d0d5e99129e526ecb4a859a36145"
ENV KBLD_VERSION "v0.25.0"
ENV KBLD_CHECKSUM "e998d54944d3b0915d4c78c3fa604163c89b9951ac1dcbdc380075cfd5aead29"

RUN \
      apt update && \
      apt -y install --fix-missing \
            docker \
            htop \
            libpython-dev \
            lsof \
            psmisc \
            python \
            strace \
            wget \
            libfontconfig1-dev libfreetype6 libssl-dev libpng-dev libjpeg-dev \
            jq \
            ruby-all-dev \
            vim \
            zip \
            python-pip \
      && \
      apt clean


# Temp fix to get around apt-key issues with canonical
RUN chmod 1777 /tmp

# gcloud SDK
RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update -y && apt-get install google-cloud-sdk -y

# install kubectl
RUN apt-get install kubectl

# Get Helm
RUN wget https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz -P /tmp && \
  tar -xvf /tmp/helm-v${HELM_VERSION}-linux-amd64.tar.gz -C /tmp && \
  mv /tmp/linux-amd64/helm /usr/local/bin/helm

# install k14s utils (ytt, kapp, kbld)
RUN  wget -O- https://github.com/k14s/ytt/releases/download/${YTT_VERSION}/ytt-linux-amd64 > /tmp/ytt && \
    echo "${YTT_CHECKSUM}  /tmp/ytt" | shasum -c - && \
    mv /tmp/ytt /usr/local/bin/ytt && \
    chmod +x /usr/local/bin/ytt

RUN wget -O- https://github.com/k14s/kapp/releases/download/${KAPP_VERSION}/kapp-linux-amd64 > /tmp/kapp && \
    echo "${KAPP_CHECKSUM}  /tmp/kapp" | shasum -c - && \
    mv /tmp/kapp /usr/local/bin/kapp && \
    chmod +x /usr/local/bin/kapp

RUN wget -O- https://github.com/k14s/kbld/releases/download/${KBLD_VERSION}/kbld-linux-amd64 > /tmp/kbld && \
    echo "${KBLD_CHECKSUM}  /tmp/kbld" | shasum -c - && \
    mv /tmp/kbld /usr/local/bin/kbld && \
    chmod +x /usr/local/bin/kbld

# Clean up
RUN apt-get remove -y python-dev apt-transport-https && \
apt-get -y clean && apt-get -y autoremove --purge && rm -rf /etc/apt/ && \
rm -rf /tmp/* && \
find /var/lib/apt/lists -type f | xargs rm -f && \
find /var/cache/debconf -type f -name '*-old' | xargs rm -f && \
find /var/log -type f -user root | xargs rm -rf && \
for file in $(find /var/log -type f -user syslog); do echo > $file; done
