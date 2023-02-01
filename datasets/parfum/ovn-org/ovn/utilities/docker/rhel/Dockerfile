FROM centos:7
MAINTAINER "Aliasgar Ginwala" <aginwala@ebay.com>

ARG OVN_BRANCH
ARG GITHUB_SRC
ARG DISTRO

copy $DISTRO/build.sh /build.sh
copy install_ovn.sh /install_ovn.sh
RUN /build.sh $OVN_BRANCH $GITHUB_SRC

COPY ovn_default_nb_port /etc/ovn/ovn_default_nb_port
COPY ovn_default_sb_port /etc/ovn/ovn_default_sb_port
COPY ovn_default_northd_host /etc/ovn/ovn_default_northd_host

COPY start-ovn /bin/start-ovn
VOLUME ["/var/log/openvswitch", \
"/var/lib/openvswitch", "/var/run/openvswitch", "/etc/openvswitch", \
"/var/log/ovn", "/var/lib/ovn", "/var/run/ovn", "/etc/ovn"]
ENTRYPOINT ["start-ovn"]
