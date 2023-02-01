FROM centos:7.7.1908

RUN yum groups mark install "Development Tools"
RUN yum groups mark convert "Development Tools"
RUN yum -y groupinstall "Development Tools"
RUN yum -y install wget && rm -rf /var/cache/yum
RUN yum -y install qt5-qtbase-devel && rm -rf /var/cache/yum
RUN yum -y install qt5-qtscript-devel && rm -rf /var/cache/yum
RUN yum -y install qt5-linguist && rm -rf /var/cache/yum
RUN yum -y install cmake && rm -rf /var/cache/yum

RUN groupadd --gid 1000 app && useradd -g app -u 1000 app
USER app
RUN id app

WORKDIR /app
