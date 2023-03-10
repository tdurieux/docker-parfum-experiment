FROM centos:7

COPY globalnoc-public-el7.repo /etc/yum.repos.d/globalnoc-public-el7.repo

RUN yum makecache
RUN yum -y install epel-release && rm -rf /var/cache/yum

RUN yum -y install perl-Carp-Always perl-Test-Deep perl-Test-Exception perl-Test-Pod perl-Test-Pod-Coverage perl-Devel-Cover nddi-tiles httpd-tools perl-Array-Utils perl-Carp-Always perl-Data-Dumper perl-Devel-Cover perl-DBI perl-DBD-mysql perl-File-Path perl-GRNOC-Config perl-Log-Log4perl perl-Net-DBus perl-Pod-Coverage perl-Test-Exception perl-Test-Deep perl-Test-Harness perl-Test-Simple perl-Test-Pod perl-Test-Pod-Coverage perl-Time-HiRes perl-XML-Simple perl-SOAP-Lite perl-NetAddr-IP perl-AnyEvent perl-AnyEvent-Fork perl-Array-Utils perl-Class-Accessor perl-Data-UUID perl-DateTime perl-Exporter perl-File-ShareDir perl-Getopt-Long perl-GRNOC-Config perl-GRNOC-Log perl-GRNOC-RabbitMQ perl-JSON perl-JSON-WebToken perl-JSON-XS perl-List-Compare perl-List-MoreUtils perl-Net-DBus perl-Net-Netconf perl-Proc-Daemon perl-Proc-ProcessTable perl-Set-Scalar perl-Socket perl-Storable perl-Switch perl-Sys-Syslog perl-Template-Toolkit perl-URI perl-XML-Simple perl-XML-Writer perl-SOAP-Lite perl-MIME-Lite-TT-HTML perl-Graph yui2 perl-Paws perl-XML-LibXML perl-GRNOC-WebService && rm -rf /var/cache/yum
RUN yum -y install perl-GRNOC-WebService-Client perl-AnyEvent-HTTP && rm -rf /var/cache/yum
RUN yum -y install grnoc-routerproxy inotify-tools && rm -rf /var/cache/yum

COPY docker/rerunner.sh /bin/rerunner.sh

COPY perl-lib/OESS/lib/OESS /usr/share/perl5/vendor_perl/OESS
COPY docker/logging.conf    /etc/oess/logging.conf
COPY docker/database.xml    /etc/oess/database.xml

COPY app/mpls/mpls_discovery.pl /bin/mpls_discovery.pl
COPY app/mpls/mpls_fwdctl.pl    /bin/mpls_fwdctl.pl

RUN mkdir /var/run/oess
RUN chown 0:0 /var/run/oess

ENTRYPOINT /bin/mpls_fwdctl.pl
