FROM centos:7


### PAN-OS-PHP
RUN mkdir /tools2

COPY install_script_centos7.sh /tools2/install_script_centos7.sh

RUN sh /tools2/install_script_centos7.sh