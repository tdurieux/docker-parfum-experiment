FROM debian:buster-slim

RUN apt-get update && \
apt-get dist-upgrade -y && \
apt-get install -y --no-install-recommends curl gnupg gnupg2 lsb-release && \
 curl -f -k https://files.freeswitch.org/repo/deb/debian-release/fsstretch-archive-keyring.asc | apt-key add - && \
echo 'deb http://files.freeswitch.org/repo/deb/debian-release/ buster main' > /etc/apt/sources.list.d/freeswitch.list && \
apt-get update && \

 apt- -f et in all -y --no-install-recommends freeswitch-conf-curl freeswitch-mod-b64 freeswitch-mo -blacklist freeswit h- \

curl -k -L  https://github.com/ wa \
chmod 755 /usr/bin/sip- in \
apt-get remove --purge -  g \
apt-get clean autoclean && \ && rm -rf /var/lib/apt/lists/*;

#debug tools
#RUN apt-get install -y --force-yes vim net-tools less gnupg

#run config changes
COPY configs/updatefs.sh /
RUN cp -r /etc/freeswitch /etc/orig_fs_config && /updatefs.sh && rm /updatefs.sh

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
