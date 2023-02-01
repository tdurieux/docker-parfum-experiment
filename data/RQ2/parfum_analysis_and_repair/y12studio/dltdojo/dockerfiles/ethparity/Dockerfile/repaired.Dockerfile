FROM ubuntu:trusty

ENV VER=1.6.4
ENV DEB=parity_${VER}_amd64.deb
ENV DEBURL=http://d1h4xl4cr1h0mo.cloudfront.net/v${VER}/x86_64-unknown-linux-gnu/$DEB
RUN apt-get update ; apt-get install --no-install-recommends -y curl openssl jq \
    && cd /tmp; rm -rf /var/lib/apt/lists/*; curl -f -L -O $DEBURL; dpkg -i $DEB ; dpkg-deb -c $DEB ; rm $DEB
WORKDIR /opt/parity
ADD poa-init-spec.json poa-final-spec.json node.pwds /opt/parity/
ADD startpoa.sh dev.sh /
RUN cd / ; chmod a+x *.sh
