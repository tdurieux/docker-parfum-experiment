ARG BASE_VERSION=latest
FROM gcr.io/istio-release/app_sidecar_base_centos_7:${BASE_VERSION}

# Install the certs.
COPY certs/                           /var/lib/istio/
COPY certs/default/*                  /var/run/secrets/istio/

# Install the sidecar components
COPY istio-sidecar-centos-7.rpm  /tmp/istio-sidecar-centos-7.rpm
RUN rpm -vi /tmp/istio-sidecar-centos-7.rpm && rm /tmp/istio-sidecar-centos-7.rpm

# Sudoers used to allow tcpdump and other debug utilities.
RUN echo "istio-proxy ALL=NOPASSWD: ALL" >> /etc/sudoers

# Install the Echo application
COPY echo-start.sh /usr/local/bin/echo-start.sh
ARG TARGETARCH
COPY ${TARGETARCH:-amd64}/client /usr/local/bin/client
COPY ${TARGETARCH:-amd64}/server /usr/local/bin/server
RUN chmod +x /usr/local/bin/client /usr/local/bin/server

ENTRYPOINT ["/usr/local/bin/echo-start.sh"]