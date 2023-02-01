FROM ubuntu:14.04
MAINTAINER Jaewoo Lee <continuse@icloud.com>

RUN apt-get update \
	&& apt-get -y --no-install-recommends install software-properties-common python-software-properties \
	&& add-apt-repository -y cloud-archive:juno \
	&& apt-get update \
	&& apt-get -y dist-upgrade \
	&& apt-get -y --no-install-recommends install python-mysqldb && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install neutron-plugin-ml2 neutron-plugin-openvswitch-agent \
    neutron-l3-agent neutron-dhcp-agent && rm -rf /var/lib/apt/lists/*;

######### controller monitoring #########
RUN apt-get -y --no-install-recommends install telnet curl ssh keepalived && rm -rf /var/lib/apt/lists/*;

######### /etc/hosts file modify #############
RUN cp /etc/hosts /tmp/hosts \
    && mkdir -p -- /lib-override && cp /lib/x86_64-linux-gnu/libnss_files.so.2 /lib-override \
    && perl -pi -e 's:/etc/hosts:/tmp/hosts:g' /lib-override/libnss_files.so.2

ENV LD_LIBRARY_PATH /lib-override
######### /etc/hosts file modify #############

COPY hostsctl.sh /hostsctl.sh
COPY entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]

EXPOSE 9696
