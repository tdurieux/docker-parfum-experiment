FROM telegraf:1.11

EXPOSE 8086 9274

# input exec plugin dependencies
RUN apt-get update; apt-get install --no-install-recommends gettext jq ntp -y && rm -rf /var/lib/apt/lists/*;

COPY ./entrypoint.sh /

RUN mkdir -p /opt/telegraf/scripts
COPY ./input-exec/*.sh.tmpl /opt/telegraf/scripts/
COPY ./input-exec/*.sh /opt/telegraf/scripts/

COPY ./telegraf.conf.tmpl /etc/telegraf/telegraf.conf.tmpl

ENTRYPOINT []
CMD /entrypoint.sh
