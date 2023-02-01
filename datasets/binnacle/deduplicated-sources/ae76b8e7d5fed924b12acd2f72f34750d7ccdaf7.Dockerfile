FROM alpine:swarm
MAINTAINER Governikus KG <ausweisapp2@governikus.com>

ENV NAME=Trigger LABELS="Trigger Seeder"

USER governikus

ENTRYPOINT ["/sbin/tini", "--"]
CMD /swarm.sh
