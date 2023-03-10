# need the helm-cli from the helm image
FROM quay.io/openshift/origin-metering-helm:latest as helm
# final image needs kubectl, so we copy `oc` from cli image to use as kubectl.
FROM quay.io/openshift/origin-cli:latest as cli
# the base image is the ansible-operator's origin images
FROM quay.io/operator-framework/ansible-operator:v1.0.1

USER root
RUN set -x; INSTALL_PKGS="curl bash ca-certificates less which openssl" \
    && yum clean all && rm -rf /var/cache/yum/* \
    && yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm  \
    && yum install --setopt=skip_missing_names_on_install=False -y \
        $INSTALL_PKGS  \
    && yum clean all \
    && rm -rf /var/cache/yum

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

COPY --from=helm /usr/local/bin/helm /usr/local/bin/helm
COPY --from=cli /usr/bin/oc /usr/bin/oc

# put tini and kubectl into our path
RUN ln -f -s /usr/bin/oc /usr/bin/kubectl
RUN ln -f -s /tini /usr/bin/tini

# List of python packages:
# 1. botocore and boto3 are used by the aws-related modules (aws_s3)
# 2. netaddr is needed to use the ipv4/ipv6 jinja filter
# 3. cryptography is used by the openssl_* modules for TLS/authentication purposes
RUN pip3 install --no-cache-dir --upgrade openshift botocore boto3 cryptography netaddr
# The ansible-operator base image will have Ansible installed by default and there's
# problems with running `pip install --upgrade` for upgrading to Ansible 2.10 from 2.9.
# This will ensure that we're always using a version of Ansible we've tested and contains
# the crypto.py FIPS fix as outlined in https://github.com/kube-reporting/metering-operator/issues/1444
RUN pip3 install --no-cache-dir --upgrade 'ansible>=2.9.6,<2.10'

ENV HOME /opt/ansible
ENV HELM_CHART_PATH ${HOME}/charts/openshift-metering

COPY images/metering-ansible-operator/roles/ ${HOME}/roles/
COPY images/metering-ansible-operator/watches.yaml ${HOME}/watches.yaml
COPY images/metering-ansible-operator/ansible.cfg /etc/ansible/ansible.cfg
COPY charts/openshift-metering ${HELM_CHART_PATH}

COPY manifests/deploy/openshift/olm/bundle /manifests

USER 1001
ENTRYPOINT ["tini", "--", "/usr/local/bin/ansible-operator", "run", "--watches-file", "/opt/ansible/watches.yaml"]

LABEL io.k8s.display-name="OpenShift metering-ansible-operator" \
      io.k8s.description="This is a component of OpenShift Container Platform and manages installation and configuration of all other metering components." \
      summary="This is a component of OpenShift Container Platform and manages installation and configuration of all other metering components." \
      io.openshift.tags="openshift" \
      com.redhat.delivery.appregistry=true \
      maintainer="<metering-team@redhat.com>"
