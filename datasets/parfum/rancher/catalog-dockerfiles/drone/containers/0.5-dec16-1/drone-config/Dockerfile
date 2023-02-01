FROM busybox

LABEL vendor="Rancher Labs, Inc." \
	com.rancher.version="0.5" \
	com.rancher.repo="https://github.com/rancher/catalog-dockerfiles"

ENV GIDDYUP_VERSION 'v0.14.0'
ENV CONFD_VERSION '0.11.0'

ADD ./confd/ /etc/confd/

ADD "https://github.com/cloudnautique/giddyup/releases/download/${GIDDYUP_VERSION}/giddyup /giddyup"
ADD "https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64 /confd"
ADD /scripts/*.sh /opt/rancher/scripts/

RUN chmod +x /confd /giddyup /opt/rancher/scripts/*

ENTRYPOINT ["/opt/rancher/scripts/rancher_drone-config_entrypoint.sh"]
CMD ["server"]

ADD Dockerfile /opt/rancher/
