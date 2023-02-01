FROM base

# Install redis
RUN apt-get update && apt-get install --no-install-recommends -y redis-server && rm -rf /var/lib/apt/lists/*;

# Run this command when the container starts
ENTRYPOINT  ["/usr/bin/redis-server"]
