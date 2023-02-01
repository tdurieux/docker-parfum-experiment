FROM mltooling/build-environment:0.6.18

# Install Java
ENV JAVA_HOME="/usr/lib/jvm/java-1.15.0-openjdk-amd64"
RUN \
    add-apt-repository ppa:openjdk-r/ppa \
    && apt-get update \
    && apt-get install --no-install-recommends -y openjdk-15-jdk \
    && dpkg-query -l && rm -rf /var/lib/apt/lists/*;

# Install docker-compose
RUN \
    curl -f -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# Install kind for Kubernetes testing
RUN \
    curl -f -Lo ./kind https://kind.sigs.k8s.io/dl/v0.9.0/kind-linux-amd64 \
    && chmod +x ./kind \
    && mv ./kind /usr/bin/kind
COPY kind-config.yaml /kind-config.yaml

# Install kubectl
RUN \
    curl -f -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.12/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

# Install lib required for psycopg2
RUN \
  apt-get update \
  && apt-get install --no-install-recommends -y libpq-dev && rm -rf /var/lib/apt/lists/*;

# Update node and yarn version
RUN apt-get update \
    && curl -f -sL https://deb.nodesource.com/setup_17.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && npm install -g yarn@1 \
    # Clean up
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* && npm cache clean --force;
ENV NODE_OPTIONS="--openssl-legacy-provider"

COPY extended-entrypoint.sh /extended-entrypoint.sh

RUN chmod +x /extended-entrypoint.sh

ENTRYPOINT ["/tini", "-g", "--", "/extended-entrypoint.sh"]
