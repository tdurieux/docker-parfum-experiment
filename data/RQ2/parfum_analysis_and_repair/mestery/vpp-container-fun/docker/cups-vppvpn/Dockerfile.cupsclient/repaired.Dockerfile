FROM vpp-container-fun/vppvpnbase
MAINTAINER mestery@mestery.com

COPY startstrongswan.sh /

ENTRYPOINT /startstrongswan.sh