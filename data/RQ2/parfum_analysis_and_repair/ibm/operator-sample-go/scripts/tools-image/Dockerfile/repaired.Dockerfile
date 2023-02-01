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

# *********** openshift oc ***************
RUN wget https://mirror.openshift.com/pub/openshift-v4/clients/oc/4.6/linux/oc.tar.gz \
    && tar -zxvf oc.tar.gz \
    && mv oc /usr/local/bin/oc && rm oc.tar.gz

# *********** IBM Cloud CLI ***********
RUN  curl -fsSL https://clis.cloud.ibm.com/install/linux | sh \
     && ibmcloud plugin install container-service \
     && ibmcloud plugin install container-registry \
     && ibmcloud plugin install code-engine \
     && ibmcloud plugin install cloud-databases

# *********** operator sdk and go ***************
RUN mkdir operator-sdk-install
WORKDIR operator-sdk-install
RUN export ARCH=$(case $(uname -m) in x86_64) echo -n amd64 ;; aarch64) echo -n arm64 ;; *) echo -n $(uname -m) ;; esac) \
    && export OS=$(uname | awk '{print tolower($0)}') \
    && export OPERATOR_SDK_DL_URL=https://github.com/operator-framework/operator-sdk/releases/download/v1.19.1 \
    && curl -f -LO ${OPERATOR_SDK_DL_URL}/operator-sdk_${OS}_${ARCH} \
    && chmod +x operator-sdk_${OS}_${ARCH} && mv operator-sdk_${OS}_${ARCH} /usr/local/bin/operator-sdk \

RUN && apt-get --assume-yes -y --no-install-recommends install golang && rm -rf /var/lib/apt/lists/*;