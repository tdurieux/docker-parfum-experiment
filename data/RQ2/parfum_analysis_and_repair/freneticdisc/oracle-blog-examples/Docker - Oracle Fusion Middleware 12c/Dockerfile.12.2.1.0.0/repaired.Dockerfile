FROM oraclelinux:7
MAINTAINER Justin Paul <justin.paul@oracle.com>

ENV _SCRATCH /tmp/scratch
ENV ORA_HOME /u01/app/oracle
ENV JDK_HOME ${ORA_HOME}/jdk
ENV FMW_HOME ${ORA_HOME}/middleware
# ENV ADM_HOME ${ORA_HOME}/admin

# COPY domain ${_SCRATCH}/domain/
# COPY scripts ${_SCRATCH}/scripts/
COPY installers ${_SCRATCH}/

RUN yum update -y -q && \
	yum install -y -q binutils compat-libcap1 compat-libstdc++-33 \
	compat-libstdc++-33.i686 gcc gcc-c++ glibc glibc-devel glibc-devel.i686 \
	libaio libaio-devel libgcc libgcc.i686 libstdc++ libstdc++.i686 \
	libstdc++-devel libXext libXtst libXi openmotif openmotif22 redhat-lsb \
	sysstat zlib zlib.i686 libX11 libX11.i686 unzip xorg-x11-utils xorg-x11-xauth \
	unzip ksh make ocfs2-tools numactl numactl-devel motif motif-devel && \
	groupadd -g 1000 oinstall && \
	useradd -u 1000 -g 1000 -m oracle && \
	mkdir -p ${ORA_HOME} && \
	chown -R oracle:oinstall ${_SCRATCH} && \
	chown -R oracle:oinstall ${ORA_HOME} && rm -rf /var/cache/yum

USER oracle

RUN	mkdir -p ${JDK_HOME} ${FMW_HOME} && \
	echo "inventory_loc=${FMW_HOME}/oraInventory" > ${_SCRATCH}/oraInst.loc && \
	echo "inst_group=oinstall" >> ${_SCRATCH}/oraInst.loc && \
	tar xzf ${_SCRATCH}/jdk-8u66-linux-x64.gz -C ${JDK_HOME} --strip-components=1 && \
	rm -rf ${_SCRATCH}/jdk-8u66-linux-x64.gz && \
	unzip ${_SCRATCH}/fmw_12.2.1.0.0_infrastructure_Disk1_1of1.zip -d ${_SCRATCH} && \
	${JDK_HOME}/bin/java -jar ${_SCRATCH}/fmw_12.2.1.0.0_infrastructure.jar \
	-novalidation -silent -responseFile ${_SCRATCH}/silent.rsp \
	-invPtrLoc ${_SCRATCH}/oraInst.loc ORACLE_HOME=${FMW_HOME} \
	INSTALL_TYPE="Fusion Middleware Infrastructure" && \
	rm -rf ${_SCRATCH}/fmw_12.2.1.0.0_infrastructure_Disk1_1of1.zip \
	${_SCRATCH}/fmw_12.2.1.0.0_infrastructure.jar && \
	export WLS_INSTALLED=1; \
	[[ -n ${WLS_INSTALLED} ]] && \
	[[ -f ${_SCRATCH}/fmw_12.2.1.0.0_bpmqs_Disk1_1of2.zip ]] && \
	[[ -f ${_SCRATCH}/fmw_12.2.1.0.0_bpmqs_Disk1_2of2.zip ]] && \
	unzip ${_SCRATCH}/fmw_12.2.1.0.0_bpmqs_Disk1_1of2.zip -d ${_SCRATCH} && \
	unzip ${_SCRATCH}/fmw_12.2.1.0.0_bpmqs_Disk1_2of2.zip -d ${_SCRATCH} && \
	${JDK_HOME}/bin/java -jar ${_SCRATCH}/fmw_12.2.1.0.0_bpm_quickstart.jar \
	-novalidation -silent -responseFile ${_SCRATCH}/silent.rsp \
	-invPtrLoc ${_SCRATCH}/oraInst.loc ORACLE_HOME=${FMW_HOME} && \
	rm -rf ${_SCRATCH}/fmw_12.2.1.0.0_bpmqs_Disk1_1of2.zip \
	${_SCRATCH}/fmw_12.2.1.0.0_bpmqs_Disk1_2of2.zip \
	${_SCRATCH}/fmw_12.2.1.0.0_bpm_quickstart.jar \
	${_SCRATCH}/fmw_12.2.1.0.0_bpm_quickstart2.jar && \
	export BPM_INSTALLED=1; \
	[[ -n ${WLS_INSTALLED} ]] && [[ -z ${BPM_INSTALLED} ]] && \
	[[ -f ${_SCRATCH}/fmw_12.2.1.0.0_soaqs_Disk1_1of2.zip ]] && \
	[[ -f ${_SCRATCH}/fmw_12.2.1.0.0_soaqs_Disk1_2of2.zip ]] && \
	unzip ${_SCRATCH}/fmw_12.2.1.0.0_soaqs_Disk1_1of2.zip -d ${_SCRATCH} && \
	unzip ${_SCRATCH}/fmw_12.2.1.0.0_soaqs_Disk1_2of2.zip -d ${_SCRATCH} && \
	${JDK_HOME}/bin/java -jar ${_SCRATCH}/fmw_12.2.1.0.0_soa_quickstart.jar \
	-novalidation -silent -responseFile ${_SCRATCH}/silent.rsp \
	-invPtrLoc ${_SCRATCH}/oraInst.loc ORACLE_HOME=${FMW_HOME} && \
	rm -rf ${_SCRATCH}/fmw_12.2.1.0.0_soaqs_Disk1_1of2.zip \
	${_SCRATCH}/fmw_12.2.1.0.0_soaqs_Disk1_2of2.zip \
	${_SCRATCH}/fmw_12.2.1.0.0_soa_quickstart.jar \
	${_SCRATCH}/fmw_12.2.1.0.0_soa_quickstart2.jar; \
	[[ -n ${WLS_INSTALLED} ]] && \
	[[ -f ${_SCRATCH}/fmw_12.2.1.0.0_wccontent_Disk1_1of1.zip ]] && \
	unzip ${_SCRATCH}/fmw_12.2.1.0.0_wccontent_Disk1_1of1.zip -d ${_SCRATCH} && \
	${JDK_HOME}/bin/java -jar ${_SCRATCH}/fmw_12.2.1.0.0_wccontent_generic.jar \
	-novalidation -silent -responseFile ${_SCRATCH}/silent.rsp \
	-invPtrLoc ${_SCRATCH}/oraInst.loc ORACLE_HOME=${FMW_HOME} \
	INSTALL_TYPE="WebCenter Content" && \
	rm -rf ${_SCRATCH}/fmw_12.2.1.0.0_wccontent_Disk1_1of1.zip \
	${_SCRATCH}/fmw_12.2.1.0.0_wccontent_generic.jar; \
	[[ -n ${WLS_INSTALLED} ]] && \
	[[ -f ${_SCRATCH}/fmw_12.2.1.0.0_wcportal_Disk1_1of1.zip ]] && \
	unzip ${_SCRATCH}/fmw_12.2.1.0.0_wcportal_Disk1_1of1.zip -d ${_SCRATCH} && \
	${JDK_HOME}/bin/java -jar ${_SCRATCH}/fmw_12.2.1.0.0_wcportal_generic.jar \
	-novalidation -silent -responseFile ${_SCRATCH}/silent.rsp \
	-invPtrLoc ${_SCRATCH}/oraInst.loc ORACLE_HOME=${FMW_HOME} \
	INSTALL_TYPE="WebCenter Portal" && \
	rm -rf ${_SCRATCH}/fmw_12.2.1.0.0_wcportal_Disk1_1of1.zip \
	${_SCRATCH}/fmw_12.2.1.0.0_wcportal_generic.jar; \
	[[ -n ${WLS_INSTALLED} ]] && \
	[[ -f ${_SCRATCH}/fmw_12.2.1.0.0_wcsites_Disk1_1of1.zip ]] && \
	unzip ${_SCRATCH}/fmw_12.2.1.0.0_wcsites_Disk1_1of1.zip -d ${_SCRATCH} && \
	${JDK_HOME}/bin/java -jar ${_SCRATCH}/fmw_12.2.1.0.0_wcsites_generic.jar \
	-novalidation -silent -responseFile ${_SCRATCH}/silent.rsp \
	-invPtrLoc ${_SCRATCH}/oraInst.loc ORACLE_HOME=${FMW_HOME} \
	INSTALL_TYPE="WebCenter Sites" && \
	rm -rf ${_SCRATCH}/fmw_12.2.1.0.0_wcsites_Disk1_1of1.zip \
	${_SCRATCH}/fmw_12.2.1.0.0_wcsites_generic.jar; \
	[[ -n ${WLS_INSTALLED} ]] && \
	[[ -f ${_SCRATCH}/fmw_12.2.1.0.0_ohs_linux64_Disk1_1of1.zip ]] && \
	unzip ${_SCRATCH}/fmw_12.2.1.0.0_ohs_linux64_Disk1_1of1.zip -d ${_SCRATCH} && \
	${_SCRATCH}/fmw_12.2.1.0.0_ohs_linux64.bin -jreLoc ${JDK_HOME} \
	-novalidation -silent -responseFile ${_SCRATCH}/silent.rsp \
	-invPtrLoc ${_SCRATCH}/oraInst.loc ORACLE_HOME=${FMW_HOME} \
	INSTALL_TYPE="Colocated HTTP Server (Managed through WebLogic server)" && \
	rm -rf ${_SCRATCH}/fmw_12.2.1.0.0_ohs_linux64_Disk1_1of1.zip \
	${_SCRATCH}/fmw_12.2.1.0.0_ohs_linux64.bin; \
	rm -rf ${_SCRATCH}

CMD /bin/bash
