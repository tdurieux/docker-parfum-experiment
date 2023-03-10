FROM nanocloud/nanocloud-frontend
MAINTAINER \
  Olivier Berthonneau <olivier.berthonneau@nanocloud.com>

ENV EMBER_CLI_INJECT_LIVE_RELOAD_BASEURL=https://localhost:4201/
ENV EMBER_CLI_INJECT_LIVE_RELOAD_PORT=49153

CMD npm install && bower install --allow-root && ember build --environment=development && ember serve --live-reload-port 49153 --port 4201 --ssl true --ssl-key /opt/ssl/nginx.key --ssl-cert /opt/ssl/nginx.crt