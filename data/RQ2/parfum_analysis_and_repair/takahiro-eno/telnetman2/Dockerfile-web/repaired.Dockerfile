FROM centos:7

ARG DBSERVER

RUN yum -y install gcc epel-release httpd mod_ssl ipa-pgothic-fonts && \
    yum -y install cpan \
     ImageMagick-perl \
     perl-GD \
     perl-CGI \
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
     perl-Data-UUID \
     perl-Data-Dumper-Concise \
     perl-Clone && \
    yum clean all && \
    echo q | /usr/bin/perl -MCPAN -e shell && \
    cpan -f GD::SecurityImage && \
    cpan -f GD::SecurityImage::AC && \
    cpan -f URI::Escape::JavaScript && \
    cpan -f IO::Pty && \
    cpan -f Net::Ping::External && \
    rm -rf /root/.cpan && \
    \cp -f /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    /usr/sbin/adduser -u 2323 -g root telnetman && \
    echo telnetman:tcpport23 | chpasswd && \
    sed -i -e 's/Options Indexes FollowSymLinks/Options MultiViews FollowSymLinks/' /etc/httpd/conf/httpd.conf && \
    sed -i -e 's/Options None/Options ExecCGI/' /etc/httpd/conf/httpd.conf && \
    sed -i -e 's/#AddHandler cgi-script \.cgi/AddHandler cgi-script .cgi/' /etc/httpd/conf/httpd.conf && \
    sed -i -e 's/DirectoryIndex index\.html/DirectoryIndex index.html index.cgi/' /etc/httpd/conf/httpd.conf && \
    sed -i -e 's/80/8080/g' /etc/httpd/conf/httpd.conf && \
    sed -i -e '/ErrorDocument 403/s/^/#/' /etc/httpd/conf.d/welcome.conf && \
    sed -i -e "\$a[SAN]\nsubjectAltName='DNS:telnetman" /etc/pki/tls/openssl.cnf && \
    sed -i -e 's/<Directory "\/var\/www\/html">/<Directory "\/var\/www\/html">\n    RewriteEngine on\n    RewriteBase \/\n    RewriteRule ^$ Telnetman2\/index.html [L]\n    RewriteCond %{REQUEST_FILENAME} !-f\n    RewriteCond %{REQUEST_FILENAME} !-d\n    RewriteRule ^(.+)$ Telnetman2\/$1 [L]\n/' /etc/httpd/conf/httpd.conf && \
    sed -i -e 's/User apache/User telnetman/' /etc/httpd/conf/httpd.conf && \
    sed -i -e 's/Group apache/Group root/' /etc/httpd/conf/httpd.conf && \
    openssl req \
     -newkey rsa:2048 \
     -days 3650 \
     -nodes \
     -x509 \
     -subj "/C=JP/ST=/L=/O=/OU=/CN=telnetman" \
     -extensions SAN \
     -reqexts SAN \
     -config /etc/pki/tls/openssl.cnf \
     -keyout /etc/pki/tls/private/server.key \
     -out /etc/pki/tls/certs/server.crt && \
    chmod 644 /etc/pki/tls/private/server.key && \
    chmod 644 /etc/pki/tls/certs/server.crt && \
    sed -i -e 's/localhost\.key/server.key/' /etc/httpd/conf.d/ssl.conf && \
    sed -i -e 's/localhost\.crt/server.crt/' /etc/httpd/conf.d/ssl.conf && \
    sed -i -e 's/443/8443/g' /etc/httpd/conf.d/ssl.conf && \
    mkdir /usr/local/Telnetman2 && \
    mkdir /usr/local/Telnetman2/lib && \
    mkdir /usr/local/Telnetman2/pl && \
    mkdir /var/www/html/Telnetman2 && \
    mkdir /var/www/html/Telnetman2/img && \
    mkdir /var/www/html/Telnetman2/img/help && \
    mkdir /var/www/html/Telnetman2/img/training && \
    mkdir /var/www/html/Telnetman2/css && \
    mkdir /var/www/html/Telnetman2/js && \
    mkdir /var/www/cgi-bin/Telnetman2 && \
    mkdir /var/Telnetman2 && rm -rf /var/cache/yum

ADD ./lib/*          /usr/local/Telnetman2/lib/
ADD ./pl/*           /usr/local/Telnetman2/pl/
ADD ./html/*         /var/www/html/Telnetman2/
ADD ./js/*           /var/www/html/Telnetman2/js/
ADD ./css/*          /var/www/html/Telnetman2/css/
ADD ./img/*png       /var/www/html/Telnetman2/img/
ADD ./img/*gif       /var/www/html/Telnetman2/img/
ADD ./img/*ico       /var/www/html/Telnetman2/img/
ADD ./img/help/*     /var/www/html/Telnetman2/img/help/
ADD ./img/training/* /var/www/html/Telnetman2/img/training/
ADD ./cgi/*          /var/www/cgi-bin/Telnetman2/

RUN sed -i -e "s/localhost/$DBSERVER/" /usr/local/Telnetman2/lib/Common_system.pm && \
    sed -i -e "s/'telnetman', 'tcpport23'/'root', ''/" /usr/local/Telnetman2/lib/Common_system.pm && \
    chown -R telnetman:root /var/Telnetman2 && \
    chmod -R 775 /var/Telnetman2 && \
    chmod 644 /usr/local/Telnetman2/lib/* && \
    chmod 644 /usr/local/Telnetman2/pl/* && \
    chmod 644 /var/www/html/Telnetman2/*html && \
    chmod 644 /var/www/html/Telnetman2/js/* && \
    chmod 644 /var/www/html/Telnetman2/css/* && \
    chmod 644 /var/www/html/Telnetman2/img/*png && \
    chmod 644 /var/www/html/Telnetman2/img/*gif && \
    chmod 644 /var/www/html/Telnetman2/img/*ico && \
    chmod 644 /var/www/html/Telnetman2/img/help/* && \
    chmod 644 /var/www/html/Telnetman2/img/training/* && \
    chmod 755 /var/www/cgi-bin/Telnetman2/* && \
    chgrp -R 0   /run/httpd && \
    chmod -R g=u /run/httpd && \
    chgrp -R 0   /var/log/httpd && \
    chmod -R g=u /var/log/httpd

ADD ./install/start-web.sh /sbin/start.sh

EXPOSE 8443

USER telnetman

CMD ["sh", "/sbin/start.sh"]
