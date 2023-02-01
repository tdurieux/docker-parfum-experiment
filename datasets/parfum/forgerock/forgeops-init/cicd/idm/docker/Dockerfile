FROM forgerock-docker-public.bintray.io/forgerock/idm:7.0.0-SNAPSHOT

RUN rm -fr /opt/openidm/conf /opt/openidm/scripts

COPY --chown=forgerock:root ./ /opt/openidm/