FROM ubuntu:22.04


### PAN-OS-PHP
RUN mkdir /tools2

COPY install_script_ubuntu22.sh /tools2/install_script_ubuntu22.sh

RUN sh /tools2/install_script_ubuntu22.sh