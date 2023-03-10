# Build arguments
ARG IMAGE_REGISTRY=prod
ARG IMAGE_TAG=latest

# Image
FROM ${IMAGE_REGISTRY}/api-base:${IMAGE_TAG}

# Update dependencies
RUN apt-get update \
# Install Crontab \
    && apt-get install --no-install-recommends -y cron \
# Clean up the apt cache
    && rm -rf /var/lib/apt/lists/*

# Copy and enable cron job file
COPY ./.docker/prod/schedule/cron.d/crontab /etc/cron.d/crontab
RUN crontab /etc/cron.d/crontab

# Set up the working directory
WORKDIR /var/www/html

# Run the cron service
CMD ["cron", "-f"]
