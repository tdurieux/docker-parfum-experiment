# need the helm-cli from the helm image
FROM registry.ci.openshift.org/ocp/4.8:metering-helm AS helm
# final image needs kubectl, so we copy `oc` from cli image to use as kubectl.
FROM registry.ci.openshift.org/ocp/4.8:cli AS cli
# real base
FROM registry.ci.openshift.org/ocp/4.8:ansible-operator

USER root
RUN set -x; \
    INSTALL_PKGS="curl bash ca-certificates \
    less which tini \
    python3-netaddr python3-botocore \
    python3-boto3 python3-openshift \
    python3-cryptography ansible openssl" \
    && yum install --setopt=skip_missing_names_on_install=False -y $INSTALL_PKGS  \
    && yum clean all \
    && rm -rf /var/cache/yum

COPY --from=helm /usr/local/bin/helm /usr/local/bin/helm
COPY --from=cli /usr/bin/oc /usr/bin/oc
RUN ln -f -s /usr/bin/oc /usr/bin/kubectl

# Ansible 2.9.6 and above is required due to the crypto.py FIPS fix
# being patched upstream: https://bugzilla.redhat.com/show_bug.cgi?id=1899136