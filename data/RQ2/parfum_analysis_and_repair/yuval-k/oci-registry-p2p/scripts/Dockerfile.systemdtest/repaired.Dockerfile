FROM fedora

RUN dnf -y install systemd systemd-libs systemd-networkd systemd-pam systemd-resolved && dnf clean all

CMD [ "/sbin/init" ]