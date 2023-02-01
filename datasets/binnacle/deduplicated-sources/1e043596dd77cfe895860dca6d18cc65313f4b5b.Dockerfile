FROM centos:latest
MAINTAINER "The CentOS Project" <admin@jiobxn.com>
ARG LATEST="0"

RUN \cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN yum -y install epel-release; yum clean all; yum -y update; yum -y install net-tools bash-completion vim wget make gcc fping httpd perl-devel rrdtool-devel rrdtool-perl perl-Sys-Syslog mailx sendmail sendmail-cf strace wqy-zenhei-fonts.noarch iptables cronie; yum clean all

RUN cd /usr/local/src \
        && wget -c http://oss.oetiker.ch/smokeping/pub/smokeping-2.6.11.tar.gz \
        && tar zxf smokeping-2.6.11.tar.gz \
        && cd /usr/local/src/smokeping-2.6.11 \
        && ./setup/build-perl-modules.sh /usr/local/smokeping/thirdparty \
        && ./configure --prefix=/usr/local/smokeping && gmake install \
        && rm -rf /usr/local/src/*

RUN cd \
        && cp /usr/local/smokeping/htdocs/smokeping.fcgi.dist /usr/local/smokeping/htdocs/smokeping.fcgi \
        && cp /usr/local/smokeping/etc/config.dist /usr/local/smokeping/etc/config \
        && mkdir -p /usr/local/smokeping/{data,cache,var} \
        && chown apache.apache /usr/local/smokeping/{data,cache,var} \
        && chmod 400 /usr/local/smokeping/etc/smokeping_secrets.dist \
        && ln -s /usr/local/smokeping/cache /usr/local/smokeping/htdocs/cache \
        && sed -i '49i charset = utf-8' /usr/local/smokeping/etc/config \
        && sed -i 's/james.address/127.0.0.1/' /usr/local/smokeping/etc/config \
        && sed -i 's/\/Test\/James \/Test\/James\~boomer/127.0.0.1/' /usr/local/smokeping/etc/config \
        && sed -i 's/Peter Random/E-Mail 联系我./' /usr/local/smokeping/etc/config \
        && sed -i 's/some@address.nowhere/admin@xxxx.com/' /usr/local/smokeping/etc/config \
        && sed -i 's/alertee@address.somewhere/admin@xxxx.com/' /usr/local/smokeping/etc/config \
        && sed -i 's/my.mail.host/localhost.localdomain/' /usr/local/smokeping/etc/config \
        && sed -i 's/smokealert@company.xy/smokeping@localhost.localdomain/' /usr/local/smokeping/etc/config \
        && sed -i 's/step     = 300/step     = 60/' /usr/local/smokeping/etc/config \
        && sed -i 's/pings    = 20/pings    = 10/' /usr/local/smokeping/etc/config \
        && sed -i 's/The most interesting destinations/网络质量监控平台/' /usr/local/smokeping/etc/config \
        && sed -i 's/ Network Latency Grapher/网络质量监控平台/' /usr/local/smokeping/etc/config \
        && sed -i 's/Welcome to the SmokePing website of xxx Company./欢迎光临！/' /usr/local/smokeping/etc/config \
        && sed -i 's/Here you will learn all about the latency of our network./在这里，可以了解到关于我们的网络延迟。/' /usr/local/smokeping/etc/config \
        && sed -i 's/Top Standard Deviation/标准偏差/' /usr/local/smokeping/etc/config \
        && sed -i 's/Top Max Roundtrip Time/最大延迟/' /usr/local/smokeping/etc/config \
        && sed -i 's/Top Median Roundtrip Time/平均延迟/' /usr/local/smokeping/etc/config \
        && sed -i 's/Top Packet Loss/丢包率/' /usr/local/smokeping/etc/config \
        && sed -i 's/Last 3 Hours/最后3 小时/' /usr/local/smokeping/etc/config \
        && sed -i 's/Last 30 Hours/最后 30 小时/' /usr/local/smokeping/etc/config \
        && sed -i 's/Last 10 Days/最后 10 天/' /usr/local/smokeping/etc/config \
        && sed -i 's/Last 400 Days/最后 400 天/' /usr/local/smokeping/etc/config \
        && sed -i 's/median rtt/平均延迟/' /usr/local/smokeping/lib/Smokeping.pm \
        && sed -i 's/:packet loss/:丢包率/' /usr/local/smokeping/lib/Smokeping.pm \
        && sed -i 's/loss color/丢包颜色/' /usr/local/smokeping/lib/Smokeping.pm \
        && sed -i 's/T:probe/T:探测器/' /usr/local/smokeping/lib/Smokeping.pm \
        && sed -i 's/:end/:结束时间/' /usr/local/smokeping/lib/Smokeping.pm \
        && sed -i 's/Navigator Graph/导航图/' /usr/local/smokeping/lib/Smokeping.pm \
        && sed -i 's/SmokeAlert/Smoke报警/' /usr/local/smokeping/lib/Smokeping.pm \
        && cp /usr/local/smokeping/etc/config /var/www/html/

RUN curl -s https://raw.githubusercontent.com/jiobxn/one/master/Docker/smokeping/smokeping.conf >/etc/httpd/conf.d/smokeping.conf

VOLUME /usr/local/smokeping/data

RUN echo -e '#!/bin/bash\nhttpd\n' >/smokeping.sh \
        && echo 'echo -e "\nconfig example:\nhttps://github.com/jiobxn/one/wiki/00023_SmokePing%E9%85%8D%E7%BD%AE\n"' >>/smokeping.sh \
        && echo -e '\nexec $@' >>/smokeping.sh
RUN chmod +x /smokeping.sh

ENTRYPOINT ["/smokeping.sh"]

EXPOSE 80

CMD ["/usr/local/smokeping/bin/smokeping", "--nodaemon"]

# docker build -t smokeping .
# docker run -d -p 8080:80 -v /docker/smokeping:/usr/local/smokeping/data --name smoke smokeping
