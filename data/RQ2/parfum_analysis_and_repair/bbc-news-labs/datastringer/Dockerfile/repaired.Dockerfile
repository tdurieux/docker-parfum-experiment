FROM ubuntu:16.04

RUN apt-get update && apt-get upgrade --yes && apt-get install --no-install-recommends --yes apt-utils \
        && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install --yes postfix \
        && apt-get install --no-install-recommends --yes nodejs \
        && apt-get install --no-install-recommends --yes npm \
        && apt-get install --no-install-recommends --yes cron && rm -rf /var/lib/apt/lists/*;

COPY . /datastringer/
COPY wizard /datastringer/wizard

WORKDIR "/datastringer"

RUN npm install && npm cache clean --force;

RUN (crontab -l ; echo "0 12 * * * nodejs /datastringer/datastringer.js") 2>&1 | sed "s/no crontab for $(whoami)//" | sort | uniq | crontab -

EXPOSE 3000

CMD [ "nodejs", "wizard.js" ]

