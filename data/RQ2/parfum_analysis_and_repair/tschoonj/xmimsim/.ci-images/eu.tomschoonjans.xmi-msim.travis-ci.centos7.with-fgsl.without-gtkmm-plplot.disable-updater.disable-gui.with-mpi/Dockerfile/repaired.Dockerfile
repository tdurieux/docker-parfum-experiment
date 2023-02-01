FROM tomschoonjans/xmimsim-travis-ci:centos7.with-fgsl.without-gtkmm-plplot.disable-updater.disable-gui

RUN yum install -y openmpi-devel && rm -rf /var/cache/yum

WORKDIR /root

RUN yum clean all
