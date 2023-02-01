# Image as build-environment
FROM python:3.10-bullseye

RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

ENV DOCKER_PACKAGE_VERSION="20.10.12~3-0"

COPY install-docker.sh /tmp/install-docker.sh

# Download the Dockerclient, because the tests need docker.
# The docker socket will be mounted in the testrunner-container later
RUN /tmp/install-docker.sh

# Install needed libs
RUN pip --disable-pip-version-check --no-cache-dir install requests PyYAML

ENTRYPOINT ["/bin/bash", "-c"]
