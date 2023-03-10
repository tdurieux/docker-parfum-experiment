FROM golang:1.12-stretch

RUN apt-get update && apt-get -y --no-install-recommends install cron python3 sudo procps && rm -rf /var/lib/apt/lists/*;

# install root cronjob
COPY docker/var/spool/cron/crontabs /var/spool/cron/crontabs
RUN chmod 600 /var/spool/cron/crontabs/root
COPY docker/root/scripts /root/scripts

# set up unpriviledged user
# allows passwordless sudo to start cron as root on startup
RUN useradd -ms /bin/bash myuser && \
    adduser myuser sudo && \
    echo 'myuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER myuser

# drop into bash shell
COPY docker/entrypoint-development.sh /entrypoint.sh
RUN sudo chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]
