FROM amazonlinux:1

RUN yum install -y upstart procps udev initscripts && rm -rf /var/cache/yum

WORKDIR /opt/cookbooks
RUN curl -f -Lo windows.tar.gz https://supermarket.chef.io/cookbooks/windows/versions/4.3.4/download && \
    tar -xzf windows.tar.gz && rm windows.tar.gz

ARG CHEF_INSTALLER_ARGS
RUN curl -f -L https://omnitruck.chef.io/install.sh | bash -s -- $CHEF_INSTALLER_ARGS

COPY tests/packaging/images/socat /bin/socat

# Insert our fake certs to the system bundle so they are trusted
COPY tests/packaging/images/certs/*.signalfx.com.* /
RUN cat /*.cert >> /etc/pki/tls/certs/ca-bundle.crt

COPY tests/packaging/images/init-fake.conf /etc/init/fake-container-events.conf

COPY deployments/chef /opt/cookbooks/signalfx_agent

WORKDIR /opt

CMD ["/sbin/init", "-v"]
