FROM debian:9.3

RUN apt-get update && apt-get --yes --no-install-recommends install curl software-properties-common gnupg && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_9.x | bash -
RUN apt-get --yes --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;

COPY monitorApp /monitorApp

RUN ( cd /monitorApp; npm install) && npm cache clean --force;

CMD (cd /monitorApp; node hostMonitor.js)
