FROM vpp-container-fun/vppvpnbase
MAINTAINER mestery@mestery.com

COPY startvpp.sh /
COPY startup.conf /etc/vpp/startup.conf

ENTRYPOINT /startvpp.sh