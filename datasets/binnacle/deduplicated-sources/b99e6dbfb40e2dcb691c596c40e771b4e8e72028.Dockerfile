FROM maven:3.5-jdk-8-alpine as build
COPY . /app/
WORKDIR /app
RUN mvn clean install dependency:copy-dependencies


FROM schaff/python-copasi-jre:latest

RUN mkdir -p /usr/local/app/lib
WORKDIR /usr/local/app

COPY --from=build \
     /app/vcell-server/target/vcell-server-0.0.1-SNAPSHOT.jar \
     /app/vcell-server/target/maven-jars/*.jar \
     /app/vcell-oracle/target/vcell-oracle-0.0.1-SNAPSHOT.jar \
     /app/vcell-oracle/target/maven-jars/*.jar \
     /app/ojdbc6/src/ojdbc6.jar \
     /app/ucp/src/ucp.jar \
     /app/vcell-api/target/vcell-api-0.0.1-SNAPSHOT.jar \
     /app/vcell-api/target/maven-jars/*.jar \
     ./lib/

COPY --from=build /app/pythonScripts ./pythonScripts
COPY --from=build /app/vcell-api/docroot ./docroot
COPY --from=build /app/vcell-api/webapp ./webapp
COPY --from=build /app/vcell-api/keystore_macbook.jks .
COPY --from=build /app/docker/vcell-api.log4j.xml .

ENV softwareVersion=SOFTWARE-VERSION-NOT-SET \
	serverid=SITE \
	dburl="db-url-not-set" \
    dbdriver="db-driver-not-set" \
    dbuser="db-user-not-set" \
    jmshost_internal=activemq \
    jmsport_internal=61616 \
    jmsrestport_internal=8161 \
    jmsuser=clientUser \
    mongodb_host_internal=mongodb \
    mongodb_port_internal=27017 \
    mongodb_database=test \
    jmsblob_minsize=100000 \
    	smtp_hostname="smtp-host-not-set" \
	smtp_port="smtp-port-not-set" \
	smtp_emailaddress="smtp-emailaddress-not-set"
    

ENV dbpswdfile=/run/secrets/dbpswd \
    jmspswdfile=/run/secrets/jmspswd \
    keystore=/run/secrets/keystorefile \
    keystorepswdfile=/run/secrets/keystorepswd

EXPOSE 8080
EXPOSE 8000

ENTRYPOINT java \
    -Xdebug -Xrunjdwp:transport=dt_socket,address=8000,server=y,suspend=n \
    -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=1 -Xms64M \
	-Dvcell.softwareVersion="${softwareVersion}" \
	-Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager \
	-Dlog4j.configurationFile=/usr/local/app/vcell-api.log4j.xml \
	-Dvcell.server.id="${serverid}" \
	-Dvcell.python.executable=/usr/bin/python \
	-Dvcell.installDir=/usr/local/app \
	-Dvcell.server.dbConnectURL="${dburl}" \
	-Dvcell.server.dbDriverName="${dbdriver}" \
	-Dvcell.server.dbUserid="${dbuser}" \
	-Dvcell.db.pswdfile="${dbpswdfile}" \
	-Dvcell.jms.host.internal="${jmshost_internal}" \
	-Dvcell.jms.port.internal="${jmsport_internal}" \
	-Dvcell.jms.restport.internal="${jmsrestport_internal}" \
	-Dvcell.jms.blobMessageUseMongo=true \
	-Dvcell.jms.blobMessageMinSize="${jmsblob_minsize}" \
	-Dvcell.jms.user="${jmsuser}" \
	-Dvcell.jms.pswdfile="${jmspswdfile}" \
	-Dvcell.mongodb.host.internal=${mongodb_host_internal} \
	-Dvcell.mongodb.port.internal=${mongodb_port_internal} \
	-Dvcell.mongodb.database=${mongodb_database} \
	-Dvcellapi.keystore.file="${keystore}" \
	-Dvcellapi.keystore.pswdfile="${keystorepswdfile}" \
	-Dvcell.smtp.hostName="${smtp_hostname}" \
	-Dvcell.smtp.port="${smtp_port}" \
	-Dvcell.smtp.emailAddress="${smtp_emailaddress}" \
	-cp "./lib/*" org.vcell.rest.VCellApiMain \
	/usr/local/app/docroot 8080
