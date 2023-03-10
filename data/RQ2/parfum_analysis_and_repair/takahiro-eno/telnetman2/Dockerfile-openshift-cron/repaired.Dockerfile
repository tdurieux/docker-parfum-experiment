FROM centos:7

ARG DBSERVER

RUN yum -y install gcc epel-release mod_ssl && \
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
ADD ./install/logrotate.sh /usr/local/bin/logrotate.sh

RUN sed -i -e "s/localhost/$DBSERVER/" /usr/local/Telnetman2/lib/Common_system.pm && \
    sed -i -e "s/'telnetman', 'tcpport23'/'root', ''/" /usr/local/Telnetman2/lib/Common_system.pm && \
    chown -R telnetman:root /var/Telnetman2 && \
    chmod -R 775 /var/Telnetman2 && \
    chmod 644 /usr/local/Telnetman2/lib/* && \
    chmod 644 /usr/local/Telnetman2/pl/*

USER telnetman
