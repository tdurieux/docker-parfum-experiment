FROM registry.fedoraproject.org/fedora:34

# standard-test-roles pulls in ansible - remove it and install ansible-core
RUN dnf update -y && PKGS="dumb-init \
    qemu-img \
    git \
    rsync \
    python3-requests \
    python3-CacheControl \
    python3-productmd \
    python3-ruamel-yaml \
    standard-test-roles" && \
    dnf -y install $PKGS && rpm -V $PKGS && \
    rpm -e --nodeps ansible && \
    dnf install -y ansible-core && \
    rpm -V ansible-core && \
    dnf clean all

RUN curl -f -s -o /usr/share/ansible/inventory/standard-inventory-qcow2 \
    https://pagure.io/fork/rmeggins/standard-test-roles/raw/linux-system-roles/f/inventory/standard-inventory-qcow2

COPY test /test
# for role2collection support
RUN curl -f -s -o /test/lsr_role2collection.py \
    https://raw.githubusercontent.com/linux-system-roles/auto-maintenance/master/lsr_role2collection.py
RUN curl -f -s -o /test/runtime.yml \
    https://raw.githubusercontent.com/linux-system-roles/auto-maintenance/master/lsr_role2collection/runtime.yml
RUN curl -f -s -o /test/runqemu.py \
    https://raw.githubusercontent.com/linux-system-roles/tox-lsr/main/src/tox_lsr/test_scripts/runqemu.py
# for callback plugin (debug, profile_tasks) support
RUN ansible-galaxy collection install -vv -p /test/collections ansible.posix && \
    mkdir -p /test/callback_plugins && \
    pushd /test/collections/ansible_collections/ansible/posix/plugins/callback && \
    mv debug.py profile_tasks.py /test/callback_plugins && \
    popd && rm -rf /test/collections

ENV COLLECTION_SRC_OWNER=linux-system-roles COLLECTION_META_RUNTIME=/test/runtime.yml \
    ANSIBLE_CALLBACK_PLUGINS=/test/callback_plugins ANSIBLE_CALLBACKS_ENABLED=profile_tasks \
    TEST_HARNESS_USE_YUM_CACHE=true TEST_HARNESS_USE_SNAPSHOT=true \
    TEST_HARNESS_SKIP_TAGS=tests::infiniband \
    ANSIBLE_STDOUT_CALLBACK=debug

VOLUME /config /secrets /cache
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/test/run-tests"]
