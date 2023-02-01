FROM docker.io/ubuntu:22.04

RUN apt-get update -qq \
    && apt-get --assume-yes -y --no-install-recommends install buildah \
    && apt-get --assume-yes -y --no-install-recommends install iptables && rm -rf /var/lib/apt/lists/*;

# Java
# *********** default-jdk -> openjdk-11-jdk ***************
RUN apt update \
    && apt-get --assume-yes -y --no-install-recommends install default-jdk && rm -rf /var/lib/apt/lists/*;

# *********** Basic tools ***************
RUN apt-get update \
    && apt-get --assume-yes -y --no-install-recommends install curl \
    && apt-get --assume-yes -y --no-install-recommends install git-core \
    && apt-get --assume-yes -y --no-install-recommends install wget \
    && apt-get --assume-yes -y --no-install-recommends install gnupg2 \
    && apt-get --assume-yes -y --no-install-recommends install nano \
    && apt-get --assume-yes -y --no-install-recommends install apt-utils \
    && apt-get --assume-yes -y --no-install-recommends install unzip \
    && apt-get --assume-yes -y --no-install-recommends install zip \
    && apt-get --assume-yes -y --no-install-recommends install sed \
    && apt-get --assume-yes -y --no-install-recommends install jq && rm -rf /var/lib/apt/lists/*;
ARG DEBIAN_FRONTEND="noninteractive"
RUN apt-get --assume-yes -y --no-install-recommends install postgresql \
    && apt-get --assume-yes -y --no-install-recommends install postgresql-contrib \
    && apt-get --assume-yes -y --no-install-recommends install original-awk && rm -rf /var/lib/apt/lists/*;

# Kubernetes
# *********** Kubernetes ***************
RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https \
    && curl -f -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list \
    && apt-get update \
    && apt-get --assume-yes -y --no-install-recommends install kubectl && rm -rf /var/lib/apt/lists/*;

# *********** IBM Cloud CLI ***********
RUN  curl -fsSL https://clis.cloud.ibm.com/install/linux | sh \
     && ibmcloud plugin install container-service \
     && ibmcloud plugin install container-registry \
     && ibmcloud plugin install code-engine \
     && ibmcloud plugin install cloud-databases
