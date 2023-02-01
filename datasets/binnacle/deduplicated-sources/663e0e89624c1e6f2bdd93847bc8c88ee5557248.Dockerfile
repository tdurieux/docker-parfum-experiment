FROM schaff/vtk-openjdk-alpine:latest

RUN mkdir -p /usr/local/app && \
	apk update && \
    apk add openssh-client && \
    apk add screen

WORKDIR /usr/local/app

COPY ./vcell-server/target/vcell-server-0.0.1-SNAPSHOT.jar \
     ./vcell-server/target/maven-jars/*.jar \
     ./lib/


COPY ./pythonScripts ./pythonScripts
COPY ./nativelibs/linux64 ./nativelibs/linux64
COPY ./docker/build/vcell-data.log4j.xml .

ENV softwareVersion=SOFTWARE-VERSION-NOT-SET \
	serverid=SITE \
    jmshost_int_internal=activemqint \
    jmsport_int_internal=61616 \
    jmsuser=clientUser \
	mongodb_host_internal=mongodb \
	mongodb_port_internal=27017 \
    mongodb_database=test \
    export_baseurl="export-baseurl-not-set" \
    simdatadir_external=/path/to/external/simdata/ \
    jmsblob_minsize=100000 \
    simdataCacheSize="simdataCacheSize-not-set" \
    servertype="servertype-not-set"

ENV jmspswdfile=/run/secrets/jmspswd

VOLUME /simdata
VOLUME /share/apps/vcell7/users
VOLUME /exportdir

EXPOSE 8000

ENTRYPOINT java \
	-Xdebug -Xrunjdwp:transport=dt_socket,address=8000,server=y,suspend=n \
	-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=1 -Xms64M \
    -Djava.awt.headless=true \
	-Dvcell.softwareVersion="${softwareVersion}" \
	-Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager \
	-Dlog4j.configurationFile=/usr/local/app/vcell-data.log4j.xml \
	-Dvcell.server.id="${serverid}" \
	-Dvcell.python.executable=/usr/bin/python \
	-Dvcell.primarySimdatadir.internal=/simdata \
	-Dvcell.primarySimdatadir.external="${simdatadir_external}" \
	-Dvcell.simdataCacheSize="${simdataCacheSize}" \
	-Dvcell.export.baseDir.internal=/exportdir/ \
	-Dvcell.export.baseURL="${export_baseurl}" \
	-Dvcell.installDir=/usr/local/app \
	-Dvcell.jms.int.host.internal="${jmshost_int_internal}" \
	-Dvcell.jms.int.port.internal="${jmsport_int_internal}" \
	-Dvcell.jms.blobMessageUseMongo=true \
	-Dvcell.jms.blobMessageMinSize="${jmsblob_minsize}" \
	-Dvcell.jms.user="${jmsuser}" \
	-Dvcell.jms.pswdfile="${jmspswdfile}" \
	-Dvcell.mongodb.host.internal=${mongodb_host_internal} \
	-Dvcell.mongodb.port.internal=${mongodb_port_internal} \
	-Dvcell.mongodb.database=${mongodb_database} \
	-cp "./lib/*" cbit.vcell.message.server.data.SimDataServer \
	"${servertype}"
