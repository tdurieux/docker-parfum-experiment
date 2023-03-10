ARG IMAGE
FROM $IMAGE
LABEL maintainer="Denis Sventitsky <denis.sventitsky@gmail.com> / Twisted Fantasy <twisteeed.fantasy@gmail.com>"

ENV CRON_PATH=/etc/cron.d/hello-cron
# Add crontab file in the cron directory
ADD cron/crontab-ubuntu $CRON_PATH

# Give execution rights on the cron job
RUN chmod 0644 $CRON_PATH

#Install Cron
RUN apt-get update && apt-get -y --no-install-recommends install cron && rm -rf /var/lib/apt/lists/*;

# Run the command on container startup
CMD ["cron", "-f"]
