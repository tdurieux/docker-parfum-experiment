FROM vpp-container-fun/base
MAINTAINER mestery@mestery.com

COPY startvpp1.sh /
COPY startup1.conf /etc/vpp/startup1.conf

ENTRYPOINT /startvpp1.sh