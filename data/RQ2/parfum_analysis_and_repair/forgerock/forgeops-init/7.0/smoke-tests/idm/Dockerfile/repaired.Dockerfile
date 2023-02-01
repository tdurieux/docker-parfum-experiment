FROM forgerock-docker-public.bintray.io/forgerock/openidm:6.5.0

RUN mkdir -p /opt/openidm/p 
COPY --chown=forgerock conf /opt/openidm/p/conf
COPY --chown=forgerock script /opt/openidm/p/script

RUN ls -lR /opt/openidm/p