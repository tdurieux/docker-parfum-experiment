# Clone from the CentOS 7
FROM centos:centos7

MAINTAINER Jan Pazdziora

RUN cd /etc/yum.repos.d && curl -f -LO https://copr.fedorainfracloud.org/coprs/g/freeipa/freeipa-4-3-centos-7/repo/epel-7/pvoborni-freeipa-4-3-centos-7-epel-7.repo
RUN yum install -y ipa-server ipa-server-dns ipa-server-trust-ad && yum clean all && rm -rf /var/cache/yum

# Workaround 1364139
RUN sed -i '/installutils.verify_fqdn(config.master_host_name, options.no_host_dns)/s/)/, local_hostname=False)/' /usr/lib/python2.7/site-packages/ipaserver/install/server/replicainstall.py && python -m compileall /usr/lib/python2.7/site-packages/ipaserver/install/server/replicainstall.py
# Workaround 1377973
RUN sed -i 's/ips.append(ipautil.CheckedIPAddress(ha, match_local=True))/ips.append(ipautil.CheckedIPAddress(ha, match_local=False))/' /usr/lib/python2.7/site-packages/ipaserver/install/installutils.py && python -m compileall /usr/lib/python2.7/site-packages/ipaserver/install/installutils.py
RUN echo '7fe9c3084d2b8ba846c23458be86c8677693f0eb /etc/tmpfiles.d/opendnssec.conf' | sha1sum --quiet -c && mv -v /etc/tmpfiles.d/opendnssec.conf /usr/lib/tmpfiles.d/opendnssec.conf
RUN echo '5a70f1f3db0608c156d5b6629d4cbc3b304fc045 /etc/systemd/system/sssd.service.d/journal.conf' | sha1sum --quiet -c && rm -vf /etc/systemd/system/sssd.service.d/journal.conf
RUN find /etc/systemd/system/* '!' -name '*.wants' | xargs rm -rvf
RUN for i in basic.target sysinit.target network.service netconsole.service ; do rm -f /usr/lib/systemd/system/$i && ln -s /dev/null /usr/lib/systemd/system/$i ; done

RUN echo LANG=C > /etc/locale.conf

RUN /sbin/ldconfig -X

COPY init-data /usr/local/sbin/init
COPY ipa-server-configure-first ipa-server-status-check exit-with-status ipa-volume-upgrade-* /usr/sbin/
COPY install.sh uninstall.sh /bin/
RUN mv /bin/hostnamectl /bin/hostnamectl.orig
RUN mv /usr/bin/domainname /usr/bin/domainname.orig
ADD hostnamectl-wrapper /bin/hostnamectl
ADD hostnamectl-wrapper /usr/bin/domainname
RUN chmod -v +x /usr/local/sbin/init /usr/sbin/ipa-server-configure-first /usr/sbin/ipa-server-status-check /usr/sbin/exit-with-status /usr/sbin/ipa-volume-upgrade-* /bin/install.sh /bin/uninstall.sh /bin/hostnamectl /usr/bin/domainname
COPY container-ipa.target ipa-server-configure-first.service ipa-server-upgrade.service ipa-server-update-self-ip-address.service /usr/lib/systemd/system/
RUN rmdir -v /etc/systemd/system/multi-user.target.wants \
	&& mkdir /etc/systemd/system/container-ipa.target.wants \
	&& ln -s /etc/systemd/system/container-ipa.target.wants /etc/systemd/system/multi-user.target.wants

RUN systemctl set-default container-ipa.target
RUN systemctl enable ipa-server-configure-first.service

COPY exit-via-chroot.conf /usr/lib/systemd/system/systemd-poweroff.service.d/

RUN groupadd -g 288 kdcproxy ; useradd -u 288 -g 288 -c 'IPA KDC Proxy User' -d '/var/lib/kdcproxy' -s '/sbin/nologin' kdcproxy

COPY atomic-install-help /usr/share/ipa/
COPY volume-data-list volume-data-mv-list volume-data-autoupdate /etc/
RUN set -e ; cd / ; mkdir /data-template ; cat /etc/volume-data-list | while read i ; do echo $i ; if [ -e $i ] ; then tar cf - .$i | ( cd /data-template && tar xf - ) ; else mkdir -p /data-template$( dirname $i ) ; fi ; mkdir -p $( dirname $i ) ; if [ "$i" == /var/log/ ] ; then mv /var/log /var/log-removed ; else rm -rf $i ; fi ; ln -sf /data${i%/} ${i%/} ; done
RUN rm -rf /var/log-removed
RUN sed -i 's!^d /var/log.*!L /var/log - - - - /data/var/log!' /usr/lib/tmpfiles.d/var.conf
RUN mv /data-template/etc/dirsrv/schema /usr/share/dirsrv/schema && ln -s /usr/share/dirsrv/schema /data-template/etc/dirsrv/schema
RUN rm -f /data-template/var/lib/systemd/random-seed
RUN echo 1.1 > /etc/volume-version

RUN sed -i 's/^UUID=/# UUID=/' /etc/fstab

ENV container docker

EXPOSE 53/udp 53 80 443 389 636 88 464 88/udp 464/udp 123/udp 7389 9443 9444 9445

VOLUME [ "/tmp", "/run", "/data", "/var/log/journal" ]

STOPSIGNAL RTMIN+3
ENTRYPOINT [ "/usr/local/sbin/init" ]
RUN uuidgen > /data-template/build-id

# Invocation:
# docker run -ti -v /sys/fs/cgroup:/sys/fs/cgroup:ro --tmpfs /run --tmpfs /tmp -v /opt/ipa-data:/data:Z -h ipa.example.test ${NAME} [ options ]

# For atomic, we run INSTALL --privileged but install.sh will start another unprivileged container.
# We do it this way to be able to set hostname for the unprivileged container.
LABEL install 'docker run -ti --rm --privileged -v /:/host -e HOST=/host -e DATADIR=/var/lib/${NAME} -e NAME=${NAME} -e IMAGE=${IMAGE} ${IMAGE} /bin/install.sh'
LABEL run 'docker run ${RUN_OPTS} --name ${NAME} -v /var/lib/${NAME}:/data:Z -v /sys/fs/cgroup:/sys/fs/cgroup:ro --tmpfs /run --tmpfs /tmp -v /dev/urandom:/dev/random:ro ${IMAGE}'
LABEL RUN_OPTS_FILE '/var/lib/${NAME}/docker-run-opts'
LABEL stop 'docker stop ${NAME}'
LABEL uninstall 'docker run --rm --privileged -v /:/host -e HOST=/host -e DATADIR=/var/lib/${NAME} ${IMAGE} /bin/uninstall.sh'
