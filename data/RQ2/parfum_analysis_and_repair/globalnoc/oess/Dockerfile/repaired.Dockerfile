FROM centos:7
COPY globalnoc-public-el7.repo /etc/yum.repos.d/globalnoc-public-el7.repo
RUN yum makecache
RUN yum -y install epel-release && rm -rf /var/cache/yum
RUN yum -y install perl mariadb-server && rm -rf /var/cache/yum
RUN yum -y install perl-Carp-Always perl-Test-Deep perl-Test-Exception perl-Test-Pod perl-Test-Pod-Coverage perl-Devel-Cover perl-AnyEvent-HTTP perl-Net-IP && rm -rf /var/cache/yum
RUN yum -y install perl-OESS oess-core oess-frontend && rm -rf /var/cache/yum

COPY . /
COPY perl-lib/OESS/entrypoint.sh /

RUN chmod 777 /entrypoint.sh
ENTRYPOINT /entrypoint.sh
