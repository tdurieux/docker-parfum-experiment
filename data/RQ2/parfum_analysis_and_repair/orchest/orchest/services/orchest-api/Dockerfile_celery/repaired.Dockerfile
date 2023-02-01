FROM python:3.8-slim
LABEL maintainer="Orchest B.V. https://www.orchest.io"

# Needed to daemonize celery workers.
RUN apt-get update \
     && apt-get install --no-install-recommends -y supervisor rsync netcat jq curl \
     && mkdir -p /var/log/supervisor && rm -rf /var/lib/apt/lists/*;

# Get all requirements in place.
COPY ./requirements.txt /orchest/services/orchest-api/
COPY ./lib/python /orchest/lib/python
COPY ./orchest-cli /orchest/orchest-cli

# Set the `WORKDIR` so the editable installs in the `requirements.txt`
# can use relative paths.
WORKDIR /orchest/services/orchest-api/
RUN pip3 install --no-cache-dir -r requirements.txt

# Application files.
COPY ./app ./app

# Daemonization settings.
COPY celery_daemon_configs/supervisord.conf /etc/supervisor/supervisord.conf
COPY celery_daemon_configs/worker_builds.conf \
     celery_daemon_configs/worker_interactive.conf \
     celery_daemon_configs/worker_jobs.conf \
     celery_daemon_configs/worker_deliveries.conf \
     /etc/supervisor/conf.d/

# To be consistent with the other services.
WORKDIR /orchest/services/orchest-api/app/

COPY ./start_celery_daemon.sh /

ARG ORCHEST_VERSION
ENV ORCHEST_VERSION=${ORCHEST_VERSION}
# -n to run in the foreground, -m is the umask of the supervisord
# process, the umask needs to be setup for each child/service process.
# -u 0 is to run as root.
ENTRYPOINT ["/start_celery_daemon.sh"]
