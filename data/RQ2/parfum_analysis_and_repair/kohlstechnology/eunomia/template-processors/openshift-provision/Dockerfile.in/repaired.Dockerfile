FROM @REPOSITORY@/eunomia-base:@IMAGE_TAG@

USER root

ENV OC_VERSION="4.7.41" \
    OPENSHIFT_PROVISION_COMMIT="2be5a143d928dbdcaa036fd89043fd99803fba98"

COPY files /files
#Upgrade pip before other pip installs to avoid issue with setuptools-rust
RUN pip3 install --no-cache-dir --upgrade pip
RUN curl -f -O https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/${OC_VERSION}/openshift-client-linux.tar.gz && \
    tar --directory /usr/bin -zxvf openshift-client-linux.tar.gz oc && \
    git clone https://github.com/KohlsTechnology/ansible-role-openshift-provision.git /files/roles/openshift-provision && \
    git -C /files/roles/openshift-provision checkout ${OPENSHIFT_PROVISION_COMMIT} && \
    pip3 install --no-cache-dir -r /files/requirements.txt && rm openshift-client-linux.tar.gz

COPY bin /usr/local/bin/

USER ${USER_UID}
