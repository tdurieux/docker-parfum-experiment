FROM vpp-container-fun/base
MAINTAINER mestery@mestery.com

COPY startvpp2.sh /
COPY startup2.conf /etc/vpp/startup2.conf

ENTRYPOINT /startvpp2.sh