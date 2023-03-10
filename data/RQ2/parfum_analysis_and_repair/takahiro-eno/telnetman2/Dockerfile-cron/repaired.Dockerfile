FROM centos:7

ARG DBSERVER

RUN yum -y install gcc epel-release mod_ssl cronie logrotate && \
    yum -y install cpan \
     perl-DBI \
     perl-DBD-MySQL \
     perl-Test-Simple \
     perl-Archive-Zip \
     perl-Net-Telnet \
     perl-JSON \
     perl-ExtUtils-MakeMaker \
     perl-Digest-MD5 \
     perl-Text-Diff \
     perl-Mail-Sendmail \
     perl-Net-OpenSSH \
     perl-TermReadKey \
     perl-Thread-Queue \
     perl-Data-UUID && \
    yum clean all && \
    echo q | /usr/bin/perl -MCPAN -e shell && \
    cpan -f URI::Escape::JavaScript && \
    cpan -f IO::Pty && \
    cpan -f Net::Ping::External && \
    rm -rf /root/.cpan && \
    \cp -f /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    /usr/sbin/adduser -u 2323 -g root telnetman && \
    echo telnetman:tcpport23 | chpasswd && \
    sed -i -e '/pam_loginuid.so/s/^/#/' /etc/pam.d/crond && \
    mkdir /usr/local/Telnetman2 && \
    mkdir /usr/local/Telnetman2/lib && \
    mkdir /usr/local/Telnetman2/pl && \
    mkdir /var/Telnetman2 && rm -rf /var/cache/yum

ADD ./lib/Access2DB.pm               /usr/local/Telnetman2/lib/
ADD ./lib/Telnetman_telnet.pm        /usr/local/Telnetman2/lib/
ADD ./lib/Telnetman_common.pm        /usr/local/Telnetman2/lib/
ADD ./lib/Common_sub.pm              /usr/local/Telnetman2/lib/
ADD ./lib/Common_system.pm           /usr/local/Telnetman2/lib/
ADD ./lib/MTping.pm                  /usr/local/Telnetman2/lib/
ADD ./lib/Reverse_polish_notation.pm /usr/local/Telnetman2/lib/
ADD ./pl/telnet.pl         /usr/local/Telnetman2/pl/
ADD ./pl/delete_session.pl /usr/local/Telnetman2/pl/
ADD ./install/Telnetman2.cron /etc/cron.d/Telnetman2.cron
ADD ./install/Telnetman2.logrotate.txt /etc/logrotate.d/Telnetman2

RUN sed -i -e "s/localhost/$DBSERVER/" /usr/local/Telnetman2/lib/Common_system.pm && \
    sed -i -e "s/'telnetman', 'tcpport23'/'root', ''/" /usr/local/Telnetman2/lib/Common_system.pm && \
    chown -R telnetman:root /var/Telnetman2 && \
    chmod -R 775 /var/Telnetman2 && \
    chmod 644 /usr/local/Telnetman2/lib/* && \
    chmod 644 /usr/local/Telnetman2/pl/* && \
    sed -i -e "s/apache/telnetman/g" /etc/cron.d/Telnetman2.cron && \
    chown root:root /etc/cron.d/Telnetman2.cron && \
    chmod 644 /etc/cron.d/Telnetman2.cron && \
    chown root:root /etc/logrotate.d/Telnetman2 && \
    chmod 644 /etc/logrotate.d/Telnetman2

ADD ./install/start-cron.sh /sbin/start.sh

CMD ["sh", "/sbin/start.sh"]
