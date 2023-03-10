FROM registry/rhel7:latest

COPY rhel7.repo ansible-el7.repo /etc/yum.repos.d/

RUN rm -f /etc/yum.repos.d/redhat.repo /var/lib/rhsm/repo_server_val/* && \
    yum install -y ansible && rpm -V ansible && \
    yum clean all && rm /etc/yum.repos.d/ansible-el7.repo && rm -rf /var/cache/yum

RUN yum update -y && \
    PKGS="rsync qemu-kvm xorriso rh-git227" && \
    yum install -y $PKGS && rpm -V $PKGS && \
    yum install -y https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-14.noarch.rpm && \
    PKGS="python2-fmf python3-pip" && \
    yum install -y $PKGS && rpm -V $PKGS && \
    yum clean all && rm /etc/yum.repos.d/rhel7.repo && \
    pip3 install --no-cache-dir cachecontrol productmd PyYAML && rm -rf /var/cache/yum

RUN if [ ! -d /usr/share/ansible/inventory ]; then \
        mkdir -p /usr/share/ansible/inventory ; \
    fi ; \
    curl -f -s -o /usr/share/ansible/inventory/standard-inventory-qcow2 \
        https://pagure.io/fork/rmeggins/standard-test-roles/raw/linux-system-roles/f/inventory/standard-inventory-qcow2 && \
    chmod +x /usr/share/ansible/inventory/standard-inventory-qcow2 && \
	sed -i -e 's,^#!/usr/bin/python3.*$,#!/usr/bin/python2,' \
	  /usr/share/ansible/inventory/standard-inventory-qcow2

RUN curl -f -s -L -o /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64
RUN chmod +x /usr/local/bin/dumb-init

COPY test /test
# for role2collection support
RUN curl -f -s -o /test/lsr_role2collection.py \
    https://raw.githubusercontent.com/linux-system-roles/auto-maintenance/master/lsr_role2collection.py
RUN curl -f -s -o /test/runtime.yml \
    https://raw.githubusercontent.com/linux-system-roles/auto-maintenance/master/lsr_role2collection/runtime.yml
RUN curl -f -s -o /test/runqemu.py \
    https://raw.githubusercontent.com/linux-system-roles/tox-lsr/main/src/tox_lsr/test_scripts/runqemu.py

ENV COLLECTION_SRC_OWNER=linux-system-roles COLLECTION_META_RUNTIME=/test/runtime.yml \
    ANSIBLE_STDOUT_CALLBACK=debug ANSIBLE_CALLBACK_WHITELIST=profile_tasks \
    TEST_HARNESS_SKIP_TAGS=tests::nvme,tests::infiniband TEST_SKIP_MISSING_DEVICE=true

VOLUME /config /secrets /cache

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]

CMD ["scl", "enable", "rh-git227", "/test/run-tests"]
