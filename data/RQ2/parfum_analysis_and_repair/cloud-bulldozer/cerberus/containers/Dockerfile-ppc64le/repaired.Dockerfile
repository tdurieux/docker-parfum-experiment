# Dockerfile for cerberus for ppc64le arch

FROM ppc64le/centos:8

MAINTAINER Red Hat OpenShift Performance and Scale

ENV KUBECONFIG /root/.kube/config

# Get kubectl and oc client for ppc64le arch
RUN curl -f -L -o kubernetes-client-linux-ppc64le.tar.gz https://dl.k8s.io/v1.19.0/kubernetes-client-linux-ppc64le.tar.gz \
&& tar xf kubernetes-client-linux-ppc64le.tar.gz && mv kubernetes/client/bin/kubectl /usr/bin/ && rm -rf kubernetes-client-linux-ppc64le.tar.gz

RUN curl -f -L -o openshift-client-linux.tar.gz https://mirror.openshift.com/pub/openshift-v4/ppc64le/clients/ocp/stable/openshift-client-linux.tar.gz \
&& tar xf openshift-client-linux.tar.gz -C /usr/bin && rm -rf openshift-client-linux.tar.gz


# Install dependencies
RUN yum install -y git python36 python3-pip gcc libffi-devel python36-devel openssl-devel gcc-c++ make && \
 pip3 install --no-cache-dir cython && \
 pip3 install --no-cache-dir numpy && \
git clone https://github.com/cloud-bulldozer/cerberus /root/cerberus && \
mkdir -p /root/.kube && cd /root/cerberus && \
 pip3 install --no-cache-dir -r requirements.txt && \
 pip3 install --no-cache-dir setuptools==40.3.0 && \
 pip3 install --no-cache-dir urllib3==1.25.4 && rm -rf /var/cache/yum

WORKDIR /root/cerberus

ENTRYPOINT python3 start_cerberus.py --config=config/config.yaml
