ARG VERSION
ARG ARCH
FROM carlosedp/docker-elasticsearch:$VERSION-$ARCH

# Override config, otherwise plug-in install will fail
ADD config /elasticsearch/config

# Set environment
ENV DISCOVERY_SERVICE elasticsearch-discovery

# Kubernetes requires swap is turned off, so memory lock is redundant
ENV MEMORY_LOCK false
