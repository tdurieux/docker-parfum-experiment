# Dockerfile for creating the management network container
FROM alpine:docker_os

#Installing packages
RUN apk add --no-cache dhcp
RUN apk add --no-cache ansible
RUN apk add --no-cache openrc
RUN apk add --no-cache py3-netaddr
RUN apk add --no-cache bash
RUN apk add --no-cache ipcalc

#Creation of directories and files
RUN mkdir /root/omnia
RUN mkdir /etc/periodic/5min
RUN touch /var/lib/dhcp/dhcpd.leases

#Copy Configuration files
COPY dhcpd.conf  /etc/dhcp/dhcpd.conf
COPY inventory_creation.yml /root/
COPY mgmt_container_configure.yml /root/
COPY cron_inv /etc/periodic/5min
