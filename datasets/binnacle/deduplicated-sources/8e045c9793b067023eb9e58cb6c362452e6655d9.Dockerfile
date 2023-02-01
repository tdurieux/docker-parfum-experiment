FROM webdevops/samson-deployment

ENV RAILS_ENV="production"
ENV PYTHONUNBUFFERED=1

# Setup
COPY etc/crontab         /etc/cron.d/samson-deployment
COPY etc/database.yml    /app/config/database.yml
COPY etc/samson.conf     /app/.env
COPY etc/provision.yml   /app/provision.yml
COPY etc/known_hosts/    /root/.known_ssh_prefetched

# Deploy ansistrano scripts
COPY ansistrano/      /opt/ansistrano/

# Deploy ssh configuration/keys
COPY ssh/             /home/application/.ssh/

COPY provision/       /opt/docker/provision/

RUN bash /opt/docker/bin/control.sh provision.role.build samson-deployment \
    && /opt/docker/bin/control.sh service.enable cron \
    && bash /opt/docker/bin/bootstrap.sh

VOLUME ["/tmp", "/storage"]
