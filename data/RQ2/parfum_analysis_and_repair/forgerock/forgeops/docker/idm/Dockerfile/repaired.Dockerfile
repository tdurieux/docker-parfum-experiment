# Note: M5 integration with AM currently not working
FROM gcr.io/forgerock-io/idm-cdk/pit1:7.3.0-latest-postcommit

COPY debian-buster-sources.list /etc/apt/sources.list

# Harden IDM by removing the Felix OSGI Console. Unless you are a ForgeRock developer, the
# console is rarely required. Your configuration should NOT include conf/felix.webconsole.json
RUN rm -f bundle/org.apache.felix.webconsole*.jar  && \
    rm -f bundle/openidm-felix-webconsole-*.jar

# Remove this once https://bugster.forgerock.org/jira/browse/OPENIDM-16100 is integrated
# This sets the RAM based on cgroups to 65% of the container memory