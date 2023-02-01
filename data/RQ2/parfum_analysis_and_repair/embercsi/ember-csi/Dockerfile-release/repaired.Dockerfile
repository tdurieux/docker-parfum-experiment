FROM quay.io/centos/centos:stream8
ARG RELEASE
ARG VERSION
ARG BUILD_DATE
ARG VCS_REF
ARG TAG

LABEL maintainers="Gorka Eguileor <geguileo@redhat.com>" \
      openstack_release=${RELEASE} \
      version=${VERSION} \
      description="Ember CSI Plugin" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.name="ember-csi" \
      org.label-schema.version=${VERSION}  \
      org.label-schema.description="Ember CSI Plugin" \
      org.label-schema.url="https://ember-csi.io" \
      org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.vcs-url="https://github.com/embercsi/ember-csi" \
      org.label-schema.vcs-ref=${VCS_REF}

# Enable RPDB debugging on this container by default
ENV PYTHONUNBUFFERED=true

# This is the default port, but if we change it via CSI_ENDPOINT then this will
# no longer be relevant.
# For the Master version expose RPDB port to support remote debugging
EXPOSE 50051 4444

RUN yum -y install --setopt=skip_missing_names_on_install=False targetcli epel-release lvm2 which && \
    yum -y install --setopt=skip_missing_names_on_install=False python3-pip python3-pywbem centos-release-openstack-${RELEASE} python3-kubernetes && \
    # Enable PowerTools so we can access python3-httplib2
    sed -i -r 's/^enabled=0/enabled=1/' /etc/yum.repos.d/CentOS-Stream-PowerTools.repo && \
    yum -y install python3-grpcio protobuf && \
    yum -y install --setopt=skip_missing_names_on_install=False python3-cinderlib xfsprogs e2fsprogs nmap-ncat && \
    # Required to apply patches
    yum -y install patch && \
    pip3 install --no-cache-dir -v "ember-csi==${VERSION}" && \
    # Remove patch package
    yum -y remove patch && \
    # Install driver specific RPM dependencies
    yum -y install --setopt=skip_missing_names_on_install=False python3-pyOpenSSL && \
    # Create the ceph repo for the ceph packages
    curl -f --silent --remote-name --location https://github.com/ceph/ceph/raw/octopus/src/cephadm/cephadm && \
    chmod +x cephadm && \
    ./cephadm add-repo --release octopus && \
    yum -y install python3-rbd ceph-common && \
    rm ./cephadm && \
    # Install driver specific PyPi dependencies
    pip3 install --no-cache-dir krest purestorage pyxcli python-3parclient python-lefthandclient && \
    yum clean all && \
    rm -rf /var/cache/yum

COPY ember-csi/nsenter-commands /

# Define default command
CMD ["ember-csi"]
