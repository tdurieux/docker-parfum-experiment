# Dockerfile for kraken

FROM ppc64le/centos:8

MAINTAINER Red Hat OpenShift Performance and Scale

ENV KUBECONFIG /root/.kube/config

RUN curl -f -L -o kubernetes-client-linux-ppc64le.tar.gz https://dl.k8s.io/v1.19.0/kubernetes-client-linux-ppc64le.tar.gz \
&& tar xf kubernetes-client-linux-ppc64le.tar.gz && mv kubernetes/client/bin/kubectl /usr/bin/ && rm -rf kubernetes-client-linux-ppc64le.tar.gz

RUN curl -f -L -o openshift-client-linux.tar.gz https://mirror.openshift.com/pub/openshift-v4/ppc64le/clients/ocp/stable/openshift-client-linux.tar.gz \
&& tar xf openshift-client-linux.tar.gz -C /usr/bin && rm -rf openshift-client-linux.tar.gz

# Install dependencies
RUN yum install epel-release -y && \
yum install -y git python36 python3-pip gcc libffi-devel python36-devel openssl-devel gcc-c++ make jq gettext && \
git clone https://github.com/cloud-bulldozer/kraken /root/kraken && \
mkdir -p /root/.kube && cd /root/kraken && \
 pip3 install --no-cache-dir cryptography==3.3.2 && \
 pip3 install --no-cache-dir -r requirements.txt setuptools==40.3.0 urllib3==1.25.4 && rm -rf /var/cache/yum

WORKDIR /root/kraken

ENTRYPOINT python3 run_kraken.py --config=config/config.yaml
