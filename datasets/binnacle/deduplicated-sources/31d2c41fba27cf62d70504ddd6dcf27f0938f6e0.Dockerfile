FROM fedora:30
MAINTAINER [FreeIPA Developers freeipa-devel@lists.fedorahosted.org]
ENV container=docker LANG=en_US.utf8 LANGUAGE=en_US.utf8 LC_ALL=en_US.utf8

ADD dist /root
RUN echo 'deltarpm = false' >> /etc/dnf/dnf.conf \
    && dnf update -y dnf \
    && dnf install -y dnf-plugins-core sudo wget systemd firewalld nss-tools iptables \
    && dnf config-manager '*modular*' --set-disabled \
    && sed -i 's/%_install_langs \(.*\)/\0:fr/g' /etc/rpm/macros.image-language-conf \
    && dnf install -y /root/rpms/*.rpm \
    && dnf clean all && rm -rf /root/rpms /root/srpms \
    && for i in /usr/lib/systemd/system/*-domainname.service; \
    do sed -i 's#^ExecStart=/#ExecStart=-/#' $i ; done

STOPSIGNAL RTMIN+3
VOLUME ["/freeipa", "/run", "/tmp"]
ENTRYPOINT [ "/usr/sbin/init" ]
