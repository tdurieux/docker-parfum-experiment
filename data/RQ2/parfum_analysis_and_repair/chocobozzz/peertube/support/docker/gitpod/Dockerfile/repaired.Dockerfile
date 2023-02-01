FROM gitpod/workspace-postgres

# Gitpod will not rebuild PeerTube's dev image unless *some* change is made to this Dockerfile.
# To trigger a rebuild, simply increase this counter:
ENV TRIGGER_REBUILD 2

# Install PeerTube's dependencies.
RUN sudo apt-get update -q && sudo apt-get install --no-install-recommends -qy \
 ffmpeg \
 openssl \
 redis-server && rm -rf /var/lib/apt/lists/*;
