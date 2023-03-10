# build stage
FROM maven:3-jdk-11 AS buildstage
WORKDIR /usr/src/sas
COPY . /usr/src/sas
ARG MVN_ARGS="-DskipTests"
# build SAS using maven
RUN mvn $MVN_ARGS package

# runnable container stage
FROM tomcat:9-jre11 AS runstage
# remove tomcat default webapps and create data directory
RUN rm -rf /usr/local/tomcat/webapps/*
# copy SAS from build image
COPY --from=buildstage /usr/src/sas/target/simpleAnnotationStore /usr/local/tomcat/webapps/ROOT
# copy properties
COPY docker/sas-solr/sas.properties /usr/local/tomcat/webapps/ROOT/WEB-INF

# use default port and entrypoint