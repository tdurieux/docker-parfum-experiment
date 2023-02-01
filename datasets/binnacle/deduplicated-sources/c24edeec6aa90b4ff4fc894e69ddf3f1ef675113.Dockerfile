# Clone from the Fedora 30 image
FROM registry.fedoraproject.org/fedora:30

MAINTAINER FreeIPA Developers <freeipa-devel@lists.fedorahosted.org>

RUN groupadd -g 288 kdcproxy ; useradd -u 288 -g 288 -c 'IPA KDC Proxy User' -d '/var/lib/kdcproxy' -s '/sbin/nologin' kdcproxy
RUN groupadd -g 289 ipaapi; useradd -u 289 -g 289 -c 'IPA Framework User' -r -d / -s '/sbin/nologin' ipaapi

# Workaround 1615948
RUN ln -s /bin/false /usr/sbin/systemd-machine-id-setup
RUN dnf upgrade -y --setopt=install_weak_deps=False \
	&& dnf install -y --setopt=install_weak_deps=False freeipa-server freeipa-server-dns freeipa-server-trust-ad patch \
	&& dnf clean all

# debug: RUN test $( getent passwd | grep -E "^(dirsrv:x:389|ipaapi:x:289|kdcproxy:x:288|pkiuser:x:17):" | wc -l ) -eq 4

# var-lib-nfs-rpc_pipefs.mount would run (and fail) nondeterministically
RUN systemctl mask rpc-gssd.service

# Container image which runs systemd
# debug: RUN test -f /etc/machine-id && ! test -s /etc/machine-id
# debug: RUN test -z "$container"
ENV container oci
ENTRYPOINT [ "/usr/sbin/init" ]
STOPSIGNAL RTMIN+3
# test-addon: VOLUME [ "/var/log/journal" ]
# test: systemd-container-failed.sh

# Minimize the systemd setup
RUN find /etc/systemd/system /usr/lib/systemd/system/{basic,multi-user,sysinit}.target.wants -type l | xargs rm -v
COPY patches/minimal-fedora-26.patch /root/
RUN patch --verbose -p0 --fuzz=0 < /root/minimal-fedora-26.patch
# debug: RUN ! find /etc/systemd/system /usr/lib/systemd/system/{basic,multi-user,sysinit}.target.wants /etc/tmpfiles.d -type f | grep .

RUN ln -s /usr/lib/systemd/system/dbus-broker.service /usr/lib/systemd/system/dbus.service
COPY container-ipa.target /usr/lib/systemd/system/
RUN systemctl set-default container-ipa.target
RUN rmdir -v /etc/systemd/system/multi-user.target.wants \
	&& mkdir /etc/systemd/system/container-ipa.target.wants \
	&& ln -s /etc/systemd/system/container-ipa.target.wants /etc/systemd/system/multi-user.target.wants
RUN systemd-tmpfiles --remove --create
# debug: RUN ! test -f /var/lib/systemd/random-seed
# test-addon: VOLUME [ "/var/log/journal" ]
# test: systemd-container-diff.sh list-dependencies-fedora-30.out docker-diff-minimal-fedora-30.exceptions docker-diff-minimal-fedora-23.out

# Prepare for basic ipa-server-install in container
# Address failing nis-domainname.service in the ipa-client-install step
RUN mv /usr/bin/nisdomainname /usr/bin/nisdomainname.orig
ADD hostnamectl-wrapper /usr/bin/nisdomainname

COPY patches/ipa-fedora-30.patch /root
RUN set -o pipefail ; patch --verbose -p0 --fuzz=0 < /root/ipa-fedora-30.patch | tee /dev/stderr | sed -n 's/^patching file //;T;/\.py$/p' | xargs python3 -m compileall

# Workaround https://github.com/freeipa/freeipa-container/issues/187
COPY certmonger-wait-for-ready.conf /usr/lib/systemd/system/certmonger.service.d/wait-for-ready.conf
# test-addon: VOLUME [ "/var/log/journal" ]
## # test: systemd-container-ipa-server-install.sh

# Move configuration and data to data volume
COPY patches/ipa-data-fedora-30.patch /root
RUN set -o pipefail ; patch --verbose -p0 --fuzz=0 < /root/ipa-data-fedora-30.patch | tee /dev/stderr | sed -n 's/^patching file //;T;/\.py$/p' | xargs python3 -m compileall

RUN mv /usr/sbin/ipa-join /usr/sbin/ipa-join.orig
COPY ipa-join /usr/sbin/ipa-join

RUN authselect select sssd with-sudo --force && mv /usr/bin/authselect /usr/bin/authselect.orig
COPY authselect /usr/bin/authselect

COPY utils/prepare-volume-template utils/populate-volume-from-template utils/extract-rpm-upgrade-scriptlets /usr/local/bin/
COPY volume-data-list volume-tmp-list volume-data-autoupdate /etc/
RUN /usr/local/bin/prepare-volume-template /etc/volume-data-list /data
RUN /usr/local/bin/prepare-volume-template /etc/volume-tmp-list /tmp
RUN /usr/local/bin/extract-rpm-upgrade-scriptlets

RUN echo 2.0 > /etc/volume-version
VOLUME [ "/tmp", "/run", "/data", "/var/log/journal" ]

COPY init-data-minimal /usr/local/sbin/init
ENTRYPOINT [ "/usr/local/sbin/init" ]
# test: systemd-container-ipa-server-install-data.sh docker-diff-minimal-fedora-23.out

# Configure master/replica upon the first invocation
COPY init-data /usr/local/sbin/init
COPY ipa-server-configure-first systemctl-exit-with-status ipa-volume-upgrade-* /usr/sbin/
COPY ipa-server-configure-first.service ipa-server-upgrade.service ipa-server-update-self-ip-address.service /usr/lib/systemd/system/
RUN ln -sv /usr/lib/systemd/system/ipa-server-configure-first.service /data-template/etc/systemd/system/container-ipa.target.wants/ipa-server-configure-first.service
COPY exit-status.conf /usr/lib/systemd/system/systemd-poweroff.service.d/

EXPOSE 53/udp 53 80 443 389 636 88 464 88/udp 464/udp 123/udp 7389 9443 9444 9445

RUN uuidgen > /data-template/build-id

# Invocation:
# docker run -ti -v /sys/fs/cgroup:/sys/fs/cgroup:ro --tmpfs /run --tmpfs /tmp -v /opt/ipa-data:/data:Z -h ipa.example.test ${NAME} [ options ]

# Atomic specific bits
COPY install.sh uninstall.sh /bin/
COPY atomic-install-help /usr/share/ipa/

# For atomic, we run INSTALL --privileged but install.sh will start another unprivileged container.
# We do it this way to be able to set hostname for the unprivileged container.
LABEL install 'docker run -ti --rm --privileged -v /:/host -e HOST=/host -e DATADIR=/var/lib/${NAME} -e NAME=${NAME} -e IMAGE=${IMAGE} ${IMAGE} /bin/install.sh'
LABEL run 'docker run ${RUN_OPTS} --name ${NAME} -v /var/lib/${NAME}:/data:Z -v /sys/fs/cgroup:/sys/fs/cgroup:ro --tmpfs /run --tmpfs /tmp -v /dev/urandom:/dev/random:ro ${IMAGE}'
LABEL RUN_OPTS_FILE '/var/lib/${NAME}/docker-run-opts'
LABEL stop 'docker stop ${NAME}'
LABEL uninstall 'docker run --rm --privileged -v /:/host -e HOST=/host -e DATADIR=/var/lib/${NAME} ${IMAGE} /bin/uninstall.sh'
