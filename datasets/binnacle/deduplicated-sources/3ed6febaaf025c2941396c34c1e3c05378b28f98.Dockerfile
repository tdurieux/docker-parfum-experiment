FROM schaff/python-copasi-jre:latest

RUN mkdir -p /usr/local/app/lib
WORKDIR /usr/local/app

COPY ./vcell-server/target/vcell-server-0.0.1-SNAPSHOT.jar \
     ./vcell-server/target/maven-jars/*.jar \
     ./vcell-oracle/target/vcell-oracle-0.0.1-SNAPSHOT.jar \
     ./vcell-oracle/target/maven-jars/*.jar \
     ./ojdbc6/src/ojdbc6.jar \
     ./ucp/src/ucp.jar \
     ./vcell-api/target/vcell-api-0.0.1-SNAPSHOT.jar \
     ./vcell-api/target/maven-jars/*.jar \
     ./lib/

COPY ./pythonScripts ./pythonScripts
COPY ./vcell-api/docroot ./docroot
COPY ./vcell-api/webapp ./webapp
COPY ./vcell-api/keystore_macbook.jks .
COPY ./docker/build/vcell-api.log4j.xml .

ENV softwareVersion=SOFTWARE-VERSION-NOT-SET \
	serverid=SITE \
	dburl="db-url-not-set" \
    dbdriver="db-driver-not-set" \
    dbuser="db-user-not-set" \
    jmshost_int_internal=activemqint \
    jmsport_int_internal=61616 \
    jmsuser=clientUser \
    mongodb_host_internal=mongodb \
    mongodb_port_internal=27017 \
    mongodb_database=test \
    jmsblob_minsize=100000 \
    smtp_hostname="smtp-host-not-set" \
	smtp_port="smtp-port-not-set" \
	smtp_emailaddress="smtp-emailaddress-not-set" \
	publicationHost="publicationHost_not_set"

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
	-Dvcell.publication.host="${publicationHost}" \
	-Dvcell.jms.int.host.internal="${jmshost_int_internal}" \
	-Dvcell.jms.int.port.internal="${jmsport_int_internal}" \
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
