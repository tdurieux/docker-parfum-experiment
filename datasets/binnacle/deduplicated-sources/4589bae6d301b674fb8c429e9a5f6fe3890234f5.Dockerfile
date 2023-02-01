FROM maven:3.5-jdk-8-alpine as build
COPY . /app/
WORKDIR /app
RUN mvn clean install dependency:copy-dependencies


FROM schaff/vtk-openjdk-alpine:latest

RUN mkdir -p /usr/local/app && \
	apk update && \
    apk add openssh-client && \
    apk add screen

WORKDIR /usr/local/app

COPY --from=build \
     /app/vcell-server/target/vcell-server-0.0.1-SNAPSHOT.jar \
     /app/vcell-server/target/maven-jars/*.jar \
     /app/vcell-oracle/target/vcell-oracle-0.0.1-SNAPSHOT.jar \
     /app/vcell-oracle/target/maven-jars/*.jar \
     /app/ojdbc6/src/ojdbc6.jar \
     /app/ucp/src/ucp.jar \
     ./lib/


COPY --from=build /app/pythonScripts ./pythonScripts
COPY --from=build /app/nativelibs/linux64 ./nativelibs/linux64
COPY --from=build /app/docker/vcell-master.log4j.xml .

ENV softwareVersion=SOFTWARE-VERSION-NOT-SET \
	serverid=SITE \
	dburl="db-url-not-set" \
    dbdriver="db-driver-not-set" \
    dbuser="db-user-not-set" \
    jmshost_internal=activemq \
    jmsport_internal=61616 \
    jmsrestport_internal=8161 \
    jmsuser=clientUser \
    jmshost_external="jms-host-external-not-set" \
    jmsport_external="jms-port-external-not-set" \
    jmsrestport_external="jms-restport-external-not-set" \
	mongodb_host_internal=mongodb \
	mongodb_port_internal=27017 \
    mongodb_database=test \
    mongodb_host_external="mongodb-host-external-not-set" \
    mongodb_port_external="mongodb-port-external-not-set" \
    export_baseurl="export-baseurl-not-set" \
    simdatadir_external=/path/to/external/simdata/ \
    simdatadir_parallel_external=/path/to/external/parallel/simdata/ \
    htclogdir_internal=/path/to/internal/htclogs/ \
    htclogdir_external=/path/to/external/htclogs/ \
    nativesolverdir_external=/path/to/external/nativesolvers/ \
    htcnodelist="" \
    singularity_imagefile=/path/to/external/singularity.img \
    docker_name="repo/namespace/vcell-batch:tag" \
    batchhost="batch-host-not-set" \
    batchuser="batch-user-not-set" \
    slurm_cmd_sbatch=sbatch \
    slurm_cmd_sacct=sacct \
    slurm_cmd_scancel=scancel \
    slurm_cmd_squeue=squeue \
    slurm_partition=vcell \
    slurm_tmpdir="slurm-tmpdir-not-set" \
    maxJobsPerScan=max-jobs-per-scan-not-set \
    maxJobsPerSite=max-jobs-per-site-not-set \
	maxOdeJobsPerUser=max-ode-jobs-per-user-not-set \
	maxPdeJobsPerUser=max-pde-jobs-per-user-not-set \
    jmsblob_minsize=100000 \
    simdataCacheSize=simdata-cache-size-not-set

ENV dbpswdfile=/run/secrets/dbpswd \
    jmspswdfile=/run/secrets/jmspswd \
    batchuserkeyfile=/run/secrets/batchuserkeyfile

VOLUME /simdata
VOLUME /exportdir
VOLUME /htclogs

EXPOSE 8000

ENTRYPOINT java \
	-Xdebug -Xrunjdwp:transport=dt_socket,address=8000,server=y,suspend=n \
	-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=1 -Xms64M \
    -Djava.awt.headless=true \
	-Dvcell.softwareVersion="${softwareVersion}" \
	-Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager \
	-Dlog4j.configurationFile=/usr/local/app/vcell-master.log4j.xml \
	-Dvcell.server.id="${serverid}" \
	-Dvcell.python.executable=/usr/bin/python \
	-Dvcell.primarySimdatadir.internal=/simdata \
	-Dvcell.simdataCacheSize="${simdataCacheSize}" \
	-Dvcell.primarySimdatadir.external="${simdatadir_external}" \
	-Dvcell.parallelDatadir.external="${simdatadir_parallel_external}" \
	-Dvcell.nativesolverdir.external="${nativesolverdir_external}" \
	-Dvcell.export.baseDir.internal=/exportdir/ \
	-Dvcell.export.baseURL="${export_baseurl}" \
	-Dvcell.htc.user="${batchuser}" \
	-Dvcell.htc.logdir.internal=/htclogs \
	-Dvcell.htc.logdir.external="${htclogdir_external}" \
	-Dvcell.htc.nodelist="${htcnodelist}" \
	-Dvcell.slurm.cmd.sbatch="${slurm_cmd_sbatch}" \
	-Dvcell.slurm.cmd.sacct="${slurm_cmd_sacct}" \
	-Dvcell.slurm.cmd.squeue="${slurm_cmd_squeue}" \
	-Dvcell.slurm.cmd.scancel="${slurm_cmd_scancel}" \
	-Dvcell.slurm.partition="${slurm_partition}" \
	-Dvcell.slurm.tmpdir="${slurm_tmpdir}" \
	-Dvcell.batch.singularity.image="${singularity_imagefile}" \
	-Dvcell.batch.docker.name="${docker_name}" \
	-Dvcell.simulation.postprocessor=JavaPostprocessor64 \
	-Dvcell.simulation.preprocessor=JavaPreprocessor64 \
	-Dvcell.javaSimulation.executable=JavaSimExe64 \
	-Dvcell.installDir=/usr/local/app \
	-Dvcell.server.dbConnectURL="${dburl}" \
	-Dvcell.server.dbDriverName="${dbdriver}" \
	-Dvcell.server.dbUserid="${dbuser}" \
	-Dvcell.db.pswdfile="${dbpswdfile}" \
	-Dvcell.jms.host.internal="${jmshost_internal}" \
	-Dvcell.jms.port.internal="${jmsport_internal}" \
	-Dvcell.jms.restport.internal="${jmsrestport_internal}" \
	-Dvcell.jms.host.external="${jmshost_external}" \
	-Dvcell.jms.port.external="${jmsport_external}" \
	-Dvcell.jms.restport.external="${jmsrestport_external}" \
	-Dvcell.jms.blobMessageUseMongo=true \
	-Dvcell.jms.blobMessageMinSize="${jmsblob_minsize}" \
	-Dvcell.jms.user="${jmsuser}" \
	-Dvcell.jms.pswdfile="${jmspswdfile}" \
	-Dvcell.mongodb.host.internal=${mongodb_host_internal} \
	-Dvcell.mongodb.port.internal=${mongodb_port_internal} \
	-Dvcell.mongodb.host.external=${mongodb_host_external} \
	-Dvcell.mongodb.port.external=${mongodb_port_external} \
	-Dvcell.mongodb.database=${mongodb_database} \
	-Dvcell.server.maxJobsPerScan=${maxJobsPerScan} \
	-Dvcell.server.maxJobsPerSite=${maxJobsPerSite} \
	-Dvcell.server.maxOdeJobsPerUser=${maxOdeJobsPerUser} \
	-Dvcell.server.maxPdeJobsPerUser=${maxPdeJobsPerUser} \
	-Dvcell.limit.jobMemoryMB=2000 \
	-cp "./lib/*" cbit.vcell.message.server.combined.VCellServices \
	"${batchhost}" "${batchuser}" "${batchuserkeyfile}"
