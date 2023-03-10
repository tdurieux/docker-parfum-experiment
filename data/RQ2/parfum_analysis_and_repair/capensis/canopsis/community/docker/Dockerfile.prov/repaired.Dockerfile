ARG CANOPSIS_TAG
ARG CANOPSIS_DISTRIBUTION


#
# Openshift compatible container
#

FROM canopsis/canopsis-core:${CANOPSIS_DISTRIBUTION}-${CANOPSIS_TAG} as prov-openshift
ADD docker/files/entrypoint-prov-sync.sh /
ADD docker/files/entrypoint-prov.sh /

VOLUME /provisioning

ENTRYPOINT /entrypoint-prov.sh
USER root
RUN sed -i 's/sudo //g' /entrypoint-prov.sh
RUN chown -R canopsis:canopsis /opt/canopsis/etc
USER canopsis

#
# Default container
#

FROM canopsis/canopsis-core:${CANOPSIS_DISTRIBUTION}-${CANOPSIS_TAG}
ADD docker/files/entrypoint-prov-sync.sh /
ADD docker/files/entrypoint-prov.sh /

VOLUME /provisioning

ENTRYPOINT /entrypoint-prov.sh