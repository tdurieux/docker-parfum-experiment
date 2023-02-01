FROM ubuntu:vivid
MAINTAINER Sébastien Rannou <mxs@sbrk.org> (@aimxhaisse)

RUN apt-get update -q -y \
 && apt-get install --no-install-recommends -q -y \
    spampd \
    libarchive-tar-perl \
    libsys-syslog-perl \
    rsyslog \
 && apt-get clean && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT rm -f /var/run/rsyslogd.pid ;	\
	   rm -f /var/run/spampd.pid ;		\
	   rsyslogd ;				\
	   spampd --host 0.0.0.0:24		\
		  --relayhost dovecot:24	\
		  --user spampd			\
		  --group spampd		\
		  --nodetach  			\
		  --tagall			\
		  --config /etc/spampd.conf
