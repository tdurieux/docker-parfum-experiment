# We take the latest Turbinia worker release as a base image to make sure dependencies are already installed
FROM us-docker.pkg.dev/osdfir-registry/turbinia/release/turbinia-worker-dev:latest

USER root

# Cleanup installed turbinia from base image
RUN pip uninstall -y turbinia
RUN rm /usr/local/bin/turbiniactl

# Create /evidence and /tmp/turbinia-mounts folders (used in local stack configuration)
RUN mkdir /evidence && chmod 777 /evidence
RUN mkdir -p /tmp/turbinia-mounts && chmod 777 /tmp/turbinia-mounts

# Install pylint, yapf and test tools
RUN pip install --no-cache-dir pylint yapf
RUN pip install --no-cache-dir mock nose coverage tox

# Install redis server
RUN apt-get -y --no-install-recommends install redis-server curl vim && rm -rf /var/lib/apt/lists/*;
# disable IPv6 in redis configuration
RUN sed -i "s/bind .*/bind 127.0.0.1/g" /etc/redis/redis.conf

# Install Google Cloud SDK
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
&& curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - \
&& apt-get update -y \
&& apt-get install --no-install-recommends google-cloud-sdk -y && rm -rf /var/lib/apt/lists/*;

# Insert dummy command to override base image CMD
CMD ["/usr/bin/ps"]
