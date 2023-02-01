FROM v2fly/v2fly-core:latest

RUN apk add --no-cache caddy
RUN apk add --no-cache gettext
RUN apk add --no-cache curl
RUN apk add --no-cache jq

COPY html /root/html/

COPY config.json.tp /root/
# COPY caddy.template.conf /root/
COPY Caddyfile /root/

ADD startup.sh /startup.sh
RUN chmod +x /startup.sh

CMD /startup.sh


