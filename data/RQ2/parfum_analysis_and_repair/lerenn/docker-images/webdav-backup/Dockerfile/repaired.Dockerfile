FROM debian:jessie
MAINTAINER Louis Fradin <louis.fradin@gmail.com>

# Install requirements
RUN apt-get update && apt-get install --no-install-recommends -y curl cron cadaver && rm -rf /var/lib/apt/lists/*;

# Prepare files
RUN mkdir /var/archives && \
    touch /var/log/cron.log

# Variables
ENV WEBDAV_HOST ""
ENV WEBDAV_USERNAME ""
ENV WEBDAV_PASSWORD ""
ENV ENCRYPTION false
ENV ENCRYPTION_PASSWORD ""
ENV SPLIT false
ENV SPLIT_SIZE 500M
ENV BACKUP_NBR -1
ENV DESTINATION_FOLDER Test
ENV TIMEOUT 120
ENV CRON true
ENV CRON_SCHEME "0 3 * * *"

# Volume
VOLUME /data

# Command
CMD ["bash", "/docker/scripts/entrypoint.sh"]

# Copy files
COPY docker /docker
