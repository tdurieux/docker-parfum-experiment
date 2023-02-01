FROM maven:3.5-jdk-8-alpine as build
COPY . /app/
WORKDIR /app
RUN mvn clean install dependency:copy-dependencies


FROM schaff/vcell-solvers:0.0.13-dev

RUN apt-get -y update && \
    apt-get install -y openjdk-8-jre-headless curl

RUN mkdir -p /usr/local/app/localsolvers && ln -s /vcellbin  /usr/local/app/localsolvers/linux64
WORKDIR /usr/local/app

COPY --from=build \
     /app/vcell-server/target/vcell-server-0.0.1-SNAPSHOT.jar \
     /app/vcell-server/target/maven-jars/*.jar \
     ./lib/

COPY --from=build /app/nativelibs/linux64 ./nativelibs/linux64
COPY --from=build \
     /app/docker/batch/JavaPreprocessor64 \
     /app/docker/batch/JavaPostprocessor64 \
     /app/docker/batch/JavaSimExe64 \
     /app/docker/batch/entrypoint.sh \
     /vcellscripts/

ENV PATH=/vcellscripts:$PATH \
    CLASSPATH=/usr/local/app/lib/*

ENV softwareVersion=SOFTWARE-VERSION-NOT-SET \
	serverid=SITE \
	installdir=/usr/local/app \
	jmshost_internal="jms-host-not-set" \
	jmsport_internal="jms-port-not-set" \
	jmsrestport_internal="jms-restport-not-set" \
    jmsuser="jms-user-not-set" \
    jmspswd="jms-pswd-not-set" \
    blob_message_use_mongo=true \
    datadir_internal=/simdata \
    datadir_external=/path/to/external/simdata \
    htclogdir_internal=/htclogs \
    htclogdir_external=/path/to/external/htclogs \
    mongodbhost_internal="mongo-host-not-set" \
    mongodbport_internal="mongo-port-not-set" \
    mongodb_database=test \
    TMPDIR=/solvertmp/ \
    jmsblob_minsize=100000

VOLUME /simdata
VOLUME /htclogs
VOLUME /solvertmp

ENTRYPOINT [ "/vcellscripts/entrypoint.sh" ]
