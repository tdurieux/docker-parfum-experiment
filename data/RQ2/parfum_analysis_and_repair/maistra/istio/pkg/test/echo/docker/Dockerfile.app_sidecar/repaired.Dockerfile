ARG VM_IMAGE_NAME=ubuntu
ARG VM_IMAGE_VERSION=bionic
ARG BASE_VERSION=latest
FROM gcr.io/istio-release/app_sidecar_base_${VM_IMAGE_NAME}_${VM_IMAGE_VERSION}:${BASE_VERSION}

# Install the certs.
COPY certs/                           /var/lib/istio/
COPY certs/default/*                  /var/run/secrets/istio/

# Install the sidecar components
COPY istio-sidecar.deb  /tmp/istio-sidecar.deb
RUN dpkg -i /tmp/istio-sidecar.deb && rm /tmp/istio-sidecar.deb

# Sudoers used to allow tcpdump and other debug utilities.
RUN echo "istio-proxy ALL=NOPASSWD: ALL" >> /etc/sudoers

# Install the Echo application
COPY echo-start.sh /usr/local/bin/echo-start.sh
ARG TARGETARCH
COPY ${TARGETARCH:-amd64}/client /usr/local/bin/client
COPY ${TARGETARCH:-amd64}/server /usr/local/bin/server
RUN chmod +x /usr/local/bin/client /usr/local/bin/server

ENTRYPOINT ["/usr/local/bin/echo-start.sh"]