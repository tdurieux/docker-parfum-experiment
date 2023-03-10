FROM fresh/centos

ARG DISTR_VERSION

ADD ./distr/setup-full-$DISTR_VERSION-x86_64.run /tmp/core/
ADD ./distr/license /tmp/core/license
ADD ./distr/*.rpm /tmp/core/

RUN yum -y localinstall /tmp/core/*.rpm ; \
    sed -i '/User apache/ s//User usr1cv8/g' /etc/httpd/conf/httpd.conf ; \
    sed -i '/Group apache/ s//Group grp1cv8/g' /etc/httpd/conf/httpd.conf ; \
    sed -i '/#ServerName www.example.com:80/ s//ServerName localhost/g' /etc/httpd/conf/httpd.conf ; \
    yum -y install x11vnc metacity net-tools gdb perl tar git jq ca-certificates ; rm -rf /var/cache/yum \
    yum -y install https://centos7.iuscommunity.org/ius-release.rpm ; \
    yum -y --setopt=tsflags=nodocs install python36u python36u-devel python36u-pip ; \
    yum -y install java-1.8.0-openjdk iproute ; \
    /tmp/core/setup-full-$DISTR_VERSION-x86_64.run --mode unattended --enable-components client_full,server,ws,ru,uk ; \
    chmod +x /tmp/core/license/1ce-installer-cli; /tmp/core/license/1ce-installer-cli install --ignore-signature-warnings ; \
    update-ca-trust ; \
    rm -rf /tmp/core ; \
    oscript /usr/share/oscript/lib/opm/src/cmd/opm.os install deployka ; \
    chmod +x /usr/bin/deployka

ENV COREDATA /var/lib/1c/data
ENV CORELOGS /var/log/1c
ENV AGENTBASEDIR /var/lib/1c/agent_data
ENV INFOBASECONNECTIONSTRING ""

VOLUME ["${COREDATA}", "${CORELOGS}", "${AGENTBASEDIR}"]

ADD ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

ADD ./dumper.py /usr/bin/dumper
RUN chmod +x /usr/bin/dumper

ENTRYPOINT ["/entrypoint.sh"]