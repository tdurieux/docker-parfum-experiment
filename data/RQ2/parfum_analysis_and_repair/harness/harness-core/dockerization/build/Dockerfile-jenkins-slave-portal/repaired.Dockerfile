#used to create image jenkins-slave-portal-open-8u242:kubectl_with_gcc

FROM base_jdk

#Install terragrunt and helm BT-310
ARG TERRAGRUNT_VERSION=v0.28.18
ARG KUBECTL_VERSION=v1.13.2
ARG PLATFORM=linux
ARG HELM_VERSION=2.17.0

USER root

COPY mongodb-org-4.4.repo /etc/yum.repos.d/
ADD https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 /usr/local/bin/terragrunt

ENV LC_ALL en_US.UTF-8
ENV PATH ${PATH}:/opt/gsutil

RUN yum update -y \
    && yum upgrade -y \
    && yum install -y hostname unzip wget mongodb-org-shell \
    #&& yum install -y https://packages.endpoint.com/rhel/7/os/x86_64/endpoint-repo-1.9-1.x86_64.rpm \
    && yum install -y git \
    && git --version \
    && curl -f -o gsutil.tar.gz https://storage.googleapis.com/pub/gsutil.tar.gz \
    && tar -xzf gsutil.tar.gz -C /opt \
    && curl -f -O https://releases.hashicorp.com/terraform/0.12.11/terraform_0.12.11_linux_amd64.zip \
    && yum install -y unzip \
    && unzip terraform_0.12.11_linux_amd64.zip \
    && chmod 755 terraform \
    && mv terraform /usr/local/bin \
    && chmod +x /usr/local/bin/terragrunt \
    && wget -O /etc/yum.repos.d/cloudfoundry-cli.repo https://packages.cloudfoundry.org/fedora/cloudfoundry-cli.repo \
    && yum install -y cf-cli \
    && curl -f -Lo /usr/local/bin/bazel https://github.com/bazelbuild/bazelisk/releases/download/v1.7.4/bazelisk-linux-amd64 \
    && chown root:root /usr/local/bin/bazel \
    && chmod 0755 /usr/local/bin/bazel \
    && bazel version \
    && curl -f -s -L -o kubectl https://app.harness.io/storage/harness-download/kubernetes-release/release/${KUBECTL_VERSION}/bin/${PLATFORM}/amd64/kubectl \
    && chmod +x kubectl \
    && mv kubectl /usr/bin \
    && wget -q https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm && rm -rf /var/cache/yum

ENV JAVA_HOME /etc/alternatives/java_sdk_1.8.0_openjdk
ENV CC /usr/bin/gcc
ENV CXX /usr/bin/g++

RUN yum group install -y "Development Tools" \
    && yum install -y centos-release-scl \
    && yum install -y devtoolset-7-gcc* \
    && yum install -y zlib-devel \
    && yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && yum install -y jq \
    && yum install -y moreutils bc \
    && scl enable devtoolset-7 bash \
    && wget https://archive.apache.org/dist/maven/maven-3/3.6.1/binaries/apache-maven-3.6.1-bin.tar.gz \
    && tar -xf apache-maven-3.6.1-bin.tar.gz && mv apache-maven-3.6.1/ /usr/local/src/apache-maven \
    && echo "export M2_HOME=/usr/local/src/apache-maven && export PATH=\${M2_HOME}/bin:\${PATH}" > /etc/profile.d/maven.sh \
    && chmod +x /etc/profile.d/maven.sh \
    && source /etc/profile.d/maven.sh \
    && rm apache-maven-3.6.1-bin.tar.gz \
    && cd / \
    && rm -rf /tmp/* && rm -rf /var/cache/yum

RUN curl -fsSL https://get.docker.com/ | sh
