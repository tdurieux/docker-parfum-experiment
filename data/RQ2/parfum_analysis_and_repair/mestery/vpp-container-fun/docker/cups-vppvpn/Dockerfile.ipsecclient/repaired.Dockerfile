FROM vpp-container-fun/vppvpnbase
MAINTAINER mestery@mestery.com

COPY startvpnclient.sh /

ENTRYPOINT /startvpnclient.sh