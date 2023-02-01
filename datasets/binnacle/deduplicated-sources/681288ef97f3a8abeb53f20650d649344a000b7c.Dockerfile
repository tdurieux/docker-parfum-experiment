FROM centos:6

RUN yum install -y upstart initscripts

COPY socat /bin/socat

# Insert our fake certs to the system bundle so they are trusted
COPY certs/*.signalfx.com.* /
RUN cat /*.cert >> /etc/pki/tls/certs/ca-bundle.crt

COPY init-fake.conf /etc/init/fake-container-events.conf

CMD ["/sbin/init", "-v"]
