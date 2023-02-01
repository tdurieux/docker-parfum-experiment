FROM ubuntu:latest
MAINTAINER Nicolas Fiorini "nicolas.fiorini@nih.gov"

RUN apt-get update && apt-get -y upgrade && apt-get -y --no-install-recommends install cron python python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install r-base && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libcurl4-gnutls-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libssl-dev && rm -rf /var/lib/apt/lists/*;

# Add crontab file in the cron directory
ADD crontab /etc/cron.d/pubrunner
ADD . /app

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/pubrunner

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Run the command on container startup
CMD cron && tail -f /var/log/cron.log
