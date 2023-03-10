# This Dockerfile uses multi-stage builds. The prep stage is used
# to prepare any needed files for use in the final image. This avoids 
# having to do cleanup inside of steps in the final image.

# Prep Stage
FROM alpine as prep

RUN apk add --no-cache unzip
RUN mkdir /prep jars
COPY maven/solr-schema-${project.version}.jar /jars
RUN unzip /jars/solr-schema-${project.version}.jar -d /prep

# Final Image Stage
FROM solr:${solr.version}
# Copy solr libs
COPY maven/jts-core-${jts.spatial4j.version}.jar /opt/solr/server/solr-webapp/webapp/WEB-INF/lib/

# Copy all solr core configurations to /seed directory
USER root
RUN mkdir /seed
COPY --from=prep /prep/solr/conf/* /seed/
COPY maven/createCore.sh /usr/local/bin/create-ddf-core
RUN chmod 755 /usr/local/bin/create-ddf-core
RUN chown -R solr:solr /seed
USER solr

# Add ddf-solr entrypoint