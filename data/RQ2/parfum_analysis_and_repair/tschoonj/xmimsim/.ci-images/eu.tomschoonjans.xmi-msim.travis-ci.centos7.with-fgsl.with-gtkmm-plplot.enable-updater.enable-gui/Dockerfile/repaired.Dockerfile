FROM tomschoonjans/xmimsim-travis-ci:centos7.with-fgsl.with-gtkmm-plplot.disable-updater.enable-gui

RUN yum install -y json-glib-devel && rm -rf /var/cache/yum

WORKDIR /root

RUN yum clean all
