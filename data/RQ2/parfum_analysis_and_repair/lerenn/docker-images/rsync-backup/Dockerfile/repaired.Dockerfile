FROM debian:jessie
MAINTAINER Louis Fradin <louis.fradin@gmail.com>

# Install requirements
RUN apt-get update \
  && apt-get install --no-install-recommends -y rsync cron openssh-client && rm -rf /var/lib/apt/lists/*;

# Environment variables
ENV BACKUP_DIR " "
ENV CRON_SCHEME "0 3 * * *"

# Volumes
VOLUME /backup
VOLUME /keys

# Copy files
COPY docker /docker

# Command
CMD [ "bash", "/docker/scripts/entrypoint.sh"]
