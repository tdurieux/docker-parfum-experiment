FROM ubuntu:14.04
MAINTAINER Jaewoo Lee <continuse@icloud.com>

RUN apt-get update \
	&& apt-get -y --no-install-recommends install software-properties-common python-software-properties \
	&& add-apt-repository -y cloud-archive:juno \
	&& apt-get update \
	&& apt-get -y dist-upgrade \
	&& apt-get -y --no-install-recommends install python-mysqldb && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install nova-compute sysfsutils && rm -rf /var/lib/apt/lists/*;

######## neutron service ###############
RUN apt-get -y --no-install-recommends install neutron-plugin-ml2 neutron-plugin-openvswitch-agent neutron-l3-agent && rm -rf /var/lib/apt/lists/*;

########## Let's start with docker in docker service ###########
RUN apt-get install --no-install-recommends -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    telnet \
    lxc \
    iptables && rm -rf /var/lib/apt/lists/*;

# Install Docker from Docker Inc. repositories.
RUN curl -f -sSL https://get.docker.com/ubuntu/ | sh
########## Let's end with docker in docker service ###########

### Docker Driver on Openstack:juno ######
RUN apt-get -y --no-install-recommends install python-pip && rm -rf /var/lib/apt/lists/*;
RUN usermod -G docker nova
RUN git clone https://github.com/stackforge/nova-docker
RUN cd /nova-docker && git checkout stable/juno \
    && sudo python setup.py install

######### /etc/hosts file modify #############
RUN cp /etc/hosts /tmp/hosts && \
    mkdir -p -- /lib-override && cp /lib/x86_64-linux-gnu/libnss_files.so.2 /lib-override && \
    perl -pi -e 's:/etc/hosts:/tmp/hosts:g' /lib-override/libnss_files.so.2

ENV LD_LIBRARY_PATH /lib-override
######### /etc/hosts file modify #############

# Glance Setup
RUN apt-get -y --no-install-recommends install glance && rm -rf /var/lib/apt/lists/*;

COPY nova-compute.conf /etc/nova/nova-compute.conf
COPY docker.filters /etc/nova/rootwrap.d/docker.filters
COPY hostsctl.sh /hostsctl.sh
COPY entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]

EXPOSE 5900 16509

