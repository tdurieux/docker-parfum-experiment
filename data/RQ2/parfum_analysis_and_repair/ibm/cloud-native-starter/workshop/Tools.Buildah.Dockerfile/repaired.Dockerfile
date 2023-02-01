FROM docker.io/ubuntu:20.10

RUN apt-get update -qq \
    && apt-get -y --no-install-recommends install buildah \
    && apt-get install --no-install-recommends -y iptables && rm -rf /var/lib/apt/lists/*;

# Java
# *********** default-jdk -> openjdk-11-jdk ***************
RUN apt update \
    && apt install --no-install-recommends -y default-jdk && rm -rf /var/lib/apt/lists/*;

# *********** Basic tools ***************
RUN apt-get update \
    && apt-get --assume-yes -y --no-install-recommends install curl \
    && apt-get --assume-yes -y --no-install-recommends install git-core \
    && apt-get --assume-yes -y --no-install-recommends install wget \
    && apt-get --assume-yes -y --no-install-recommends install gnupg2 \
    && apt-get --assume-yes -y --no-install-recommends install nano \
    && apt-get --assume-yes -y --no-install-recommends install apt-utils \
    && apt-get --assume-yes -y --no-install-recommends install unzip \
    && apt-get --assume-yes -y --no-install-recommends install zip && rm -rf /var/lib/apt/lists/*;

# Kubernetes
# *********** Kubernetes ***************
RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https \
    && curl -f -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list \
    && apt-get update \
    && apt-get install --no-install-recommends -y kubectl && rm -rf /var/lib/apt/lists/*;

# *********** IBM Cloud CLI ***********
RUN  curl -fsSL https://clis.cloud.ibm.com/install/linux | sh \
     && ibmcloud plugin install container-service \
     && ibmcloud plugin install container-registry

# Docker CLI
# *********** Docker *************** "
WORKDIR /
RUN apt install --no-install-recommends -y gnupg \
    && apt install --no-install-recommends -y docker.io \
    && docker --version && rm -rf /var/lib/apt/lists/*;
