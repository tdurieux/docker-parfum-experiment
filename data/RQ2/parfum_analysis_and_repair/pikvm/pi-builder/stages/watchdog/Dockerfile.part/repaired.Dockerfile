RUN pkg-install watchdog

COPY stages/watchdog/watchdog.conf /etc/watchdog.conf

RUN systemctl enable watchdog