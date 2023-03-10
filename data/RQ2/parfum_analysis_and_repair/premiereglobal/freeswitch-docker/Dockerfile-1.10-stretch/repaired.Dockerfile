FROM debian:stretch-slim

RUN apt-get update && \
apt-get dist-upgrade -y && \
apt-get install -y --no-install-recommends curl gnupg && \
 curl -f -k https://files.freeswitch.org/repo/deb/freeswitch-1.8/fsstretch-archive-keyring.asc | apt-key add - && \
echo 'deb http://files.freeswitch.org/repo/deb/freeswitch-1.8/ stretch main' > /etc/apt/sources.list.d/freeswitch.list && \
apt-get update && \
apt-get install -y --no-install-recommends freeswitch-conf-curl freeswitch-mod-b64 freeswitch-mod-blacklist freeswitch-mod-cdr-csv freeswitch-mod-cdr-sqlite freeswitch-mod-cidlookup freeswitch-mod-commands freeswitch-mod-conference freeswitch-mod-console freeswitch-mod-curl freeswitch-mod-db freeswitch-mod-dialplan-xml freeswitch-mod-dptools freeswitch-mod-enum freeswitch-mod-event-socket freeswitch-mod-expr freeswitch-mod-fifo freeswitch-mod-format-cdr freeswitch-mod-fsv freeswitch-mod-g723-1 freeswitch-mod-g729 freeswitch-mod-graylog2 freeswitch-mod-hash freeswitch-mod-httapi freeswitch-mod-json-cdr freeswitch-mod-local-stream freeswitch-mod-logfile freeswitch-mod-loopback freeswitch-mod-lua freeswitch-mod-native-file freeswitch-mod-opus freeswitch-mod-posix-timer freeswitch-mod-prefix freeswitch-mod-python freeswitch-mod-radius-cdr freeswitch-mod-random freeswitch-mod-rtc freeswitch-mod-sndfile freeswitch-mod-snmp freeswitch-mod-sofia freeswitch-mod-spandsp freeswitch-mod-spy freeswitch-mod-syslog freeswitch-mod-timerfd freeswitch-mod-tone-stream freeswitch-mod-valet-parking freeswitch-mod-xml-cdr freeswitch-mod-xml-curl freeswitch-mod-xml-rpc freeswitch-mod-yaml freeswitch-timezones freeswitch-conf-vanilla freeswitch freeswitch-mod-av dumb-init freeswitch-mod-v8 curl && \
 curl -f -k -L https://github.com/lwahlmeier/sip-ping/releases/download/v1.0.0/sip-ping-linux-amd64 > /usr/bin/sip-ping && \
chmod 755 /usr/bin/sip-ping && \
apt-get remove --purge -y gnupg && \
apt-get clean autoclean && \
apt-get autoremove --yes && \
rm -rf /var/lib/{apt,dpkg,cache,log}/ && rm -rf /var/lib/apt/lists/*;

#debug tools
#RUN apt-get install -y --force-yes vim net-tools less gnupg

#run config changes
COPY configs/updatefs.sh /
RUN /updatefs.sh
RUN rm /updatefs.sh

#add generic profile
COPY configs/sip-profile.xml /etc/freeswitch/sip_profiles/
#add generic config
COPY configs/sip-dialplan.xml /etc/freeswitch/dialplan/
#add generic conference config
COPY configs/conference.conf.xml /etc/freeswitch/autoload_configs/
COPY configs/json_cdr.conf.xml /etc/freeswitch/autoload_configs/
#add run.sh
COPY run.sh /
RUN touch /env.sh

ENV FS_SQLITE_MEMORY="true"

ENTRYPOINT ["/run.sh"]
CMD ["/usr/bin/freeswitch", "-nonat", "-nf", "-nc"]
