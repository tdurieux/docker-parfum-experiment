# Copied  from https://github.com/adelton/docker-freeipa/Dockerfile.centos-7  (23ae0a2)
# Clone from the CentOS 7
FROM centos:centos7

MAINTAINER Mesosphere support@mesosphere.io

RUN cd /etc/yum.repos.d && curl -LO https://copr.fedorainfracloud.org/coprs/g/freeipa/freeipa-4-3-centos-7/repo/epel-7/pvoborni-freeipa-4-3-centos-7-epel-7.repo
RUN mkdir -p /run/lock && yum install -y ipa-server ipa-server-dns ipa-server-trust-ad && yum clean all

RUN echo '7fe9c3084d2b8ba846c23458be86c8677693f0eb /etc/tmpfiles.d/opendnssec.conf' | sha1sum --quiet -c && mv -v /etc/tmpfiles.d/opendnssec.conf /usr/lib/tmpfiles.d/opendnssec.conf
RUN echo '5a70f1f3db0608c156d5b6629d4cbc3b304fc045 /etc/systemd/system/sssd.service.d/journal.conf' | sha1sum --quiet -c && rm -vf /etc/systemd/system/sssd.service.d/journal.conf
RUN find /etc/systemd/system/* '!' -name '*.wants' | xargs rm -rvf
RUN for i in basic.target sysinit.target network.service netconsole.service ; do rm -f /usr/lib/systemd/system/$i && ln -s /dev/null /usr/lib/systemd/system/$i ; done

RUN echo LANG=C > /etc/locale.conf

RUN /sbin/ldconfig -X

COPY assets/init-data assets/ipa-server-configure-first assets/ipa-server-status-check assets/exit-with-status assets/ipa-volume-upgrade-* /usr/sbin/
COPY assets/install.sh assets/uninstall.sh /bin/
RUN chmod -v +x /usr/sbin/init-data /usr/sbin/ipa-server-configure-first /usr/sbin/ipa-server-status-check /usr/sbin/exit-with-status /usr/sbin/ipa-volume-upgrade-* /bin/install.sh /bin/uninstall.sh
COPY assets/container-ipa.target assets/ipa-server-configure-first.service assets/ipa-server-upgrade.service assets/ipa-server-update-self-ip-address.service assets/kill-tail.service /usr/lib/systemd/system/
RUN rmdir -v /etc/systemd/system/multi-user.target.wants \
	&& mkdir /etc/systemd/system/container-ipa.target.wants \
	&& ln -s /etc/systemd/system/container-ipa.target.wants /etc/systemd/system/multi-user.target.wants
RUN mkdir -p /usr/lib/systemd/system/shutdown.target.wants && ln -sf /usr/lib/systemd/system/kill-tail.service /usr/lib/systemd/system/shutdown.target.wants/kill-tail.service

RUN systemctl set-default container-ipa.target
RUN systemctl enable ipa-server-configure-first.service

COPY assets/exit-via-chroot.conf /usr/lib/systemd/system/systemd-poweroff.service.d/

RUN groupadd -g 389 dirsrv ; useradd -u 389 -g 389 -c 'DS System User' -d '/var/lib/dirsrv' --no-create-home -s '/sbin/nologin' dirsrv
RUN groupadd -g 288 kdcproxy ; useradd -u 288 -g 288 -c 'IPA KDC Proxy User' -d '/var/lib/kdcproxy' -s '/sbin/nologin' kdcproxy

COPY assets/atomic-install-help /usr/share/ipa/
COPY assets/volume-data-list assets/volume-data-mv-list assets/volume-data-autoupdate /etc/
RUN set -e ; cd / ; mkdir /data-template ; cat /etc/volume-data-list | while read i ; do echo $i ; if [ -e $i ] ; then tar cf - .$i | ( cd /data-template && tar xf - ) ; fi ; mkdir -p $( dirname $i ) ; if [ "$i" == /var/log/ ] ; then mv /var/log /var/log-removed ; else rm -rf $i ; fi ; ln -sf /data${i%/} ${i%/} ; done
RUN rm -rf /var/log-removed
RUN sed -i 's!^d /var/log.*!L /var/log - - - - /data/var/log!' /usr/lib/tmpfiles.d/var.conf
RUN mv /data-template/etc/dirsrv/schema /usr/share/dirsrv/schema && ln -s /usr/share/dirsrv/schema /data-template/etc/dirsrv/schema
RUN rm -f /data-template/var/lib/systemd/random-seed
RUN echo 1.1 > /etc/volume-version

RUN for i in /usr/lib/systemd/system/*-domainname.service ; do sed -i 's#^ExecStart=/#ExecStart=-/#' $i ; done

RUN sed -i 's/^UUID=/# UUID=/' /etc/fstab

ENV container docker

EXPOSE 53/udp 53 80 443 389 636 88 464 88/udp 464/udp 123/udp 7389 9443 9444 9445

VOLUME [ "/tmp", "/run", "/data" ]

STOPSIGNAL RTMIN+3
ENTRYPOINT [ "/usr/sbin/init-data" ]
RUN uuidgen > /data-template/build-id

# Invocation:
# docker run -ti -v /sys/fs/cgroup:/sys/fs/cgroup:ro --tmpfs /run --tmpfs /tmp -v /opt/ipa-data:/data:Z -h ipa.example.test ${NAME} [ options ]

# For atomic, we run INSTALL --privileged but install.sh will start another unprivileged container.
# We do it this way to be able to set hostname for the unprivileged container.
LABEL INSTALL 'docker run -ti --rm --privileged -v /:/host -e HOST=/host -e DATADIR=/var/lib/${NAME} -e NAME=${NAME} -e IMAGE=${IMAGE} ${IMAGE} /bin/install.sh'
LABEL RUN 'docker run ${RUN_OPTS} --name ${NAME} -v /var/lib/${NAME}:/data:Z -v /sys/fs/cgroup:/sys/fs/cgroup:ro --tmpfs /run --tmpfs /tmp -v /dev/urandom:/dev/random:ro ${IMAGE}'
LABEL RUN_OPTS_FILE '/var/lib/${NAME}/docker-run-opts'
LABEL STOP 'docker stop ${NAME}'
LABEL UNINSTALL 'docker run --rm --privileged -v /:/host -e HOST=/host -e DATADIR=/var/lib/${NAME} ${IMAGE} /bin/uninstall.sh'
