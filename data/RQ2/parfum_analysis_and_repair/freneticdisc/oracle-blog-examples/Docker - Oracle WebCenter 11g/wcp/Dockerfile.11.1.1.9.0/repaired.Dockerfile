FROM oraclelinux:6
MAINTAINER Justin Paul <justin.paul@oracle.com>

ENV _SCRATCH /tmp/scratch
ENV ORA_HOME /u01/app/oracle
ENV JDK_HOME ${ORA_HOME}/product/jdk
ENV FMW_HOME ${ORA_HOME}/product/fmw
ENV ADM_HOME ${ORA_HOME}/admin

COPY jdk ${_SCRATCH}/jdk/
COPY wls ${_SCRATCH}/wls/
COPY rcu ${_SCRATCH}/rcu/
COPY wcp ${_SCRATCH}/wcp/
COPY domain ${_SCRATCH}/domain/
COPY scripts ${_SCRATCH}/scripts/

RUN yum update -y -q && \
	yum install -y -q binutils compat-libcap1 compat-libstdc++-33 \
	compat-libstdc++-33.i686 gcc gcc-c++ glibc glibc-devel glibc-devel.i686 \
	libaio libaio-devel libgcc libgcc.i686 libstdc++ libstdc++.i686 \
	libstdc++-devel libXext libXtst libXi openmotif openmotif22 redhat-lsb \
	sysstat zlib zlib.i686 libX11 libX11.i686 unzip xorg-x11-utils xorg-x11-xauth && \
	groupadd -g 1000 oinstall && \
	useradd -u 1000 -g 1000 -m oracle && \
	mkdir -p ${ORA_HOME} && \
	chown -R oracle:oinstall ${_SCRATCH} && \
	chown -R oracle:oinstall ${ORA_HOME} && rm -rf /var/cache/yum

USER oracle

RUN unzip -qq ${_SCRATCH}/jdk/p21984104_17091_Linux-x86-64.zip -d ${_SCRATCH}/jdk && \
	mkdir -p ${JDK_HOME} && \
	tar xzf ${_SCRATCH}/jdk/jdk-7u91-linux-x64.tar.gz -C ${JDK_HOME} --strip-components=1 && \
	rm -rf ${_SCRATCH}/jdk && \
	mkdir -p ${FMW_HOME} && \
	${JDK_HOME}/bin/java -jar ${_SCRATCH}/wls/wls1036_generic.jar -mode=silent \
	-silent_xml=${_SCRATCH}/wls/silent.xml && \
	rm -rf ${_SCRATCH}/wls/wls1036_generic.jar ${_SCRATCH}/wls/silent.xml && \
	unzip -qq ${_SCRATCH}/rcu/ofm_rcu_linux_11.1.1.9.0_64_disk1_1of1.zip -d ${FMW_HOME} && \
	rm -rf ${_SCRATCH}/rcu/ofm_rcu_linux_11.1.1.9.0_64_disk1_1of1.zip && \
	echo "inventory_loc=${FMW_HOME}/oraInventory" > ${_SCRATCH}/oraInst.loc && \
	echo "inst_group=oinstall" >> ${_SCRATCH}/oraInst.loc && \
	unzip -qq ${_SCRATCH}/wcp/ofm_wc_generic_11.1.1.9.0_disk1_1of2.zip -d ${_SCRATCH}/wcp && \
	unzip -qq ${_SCRATCH}/wcp/ofm_wc_generic_11.1.1.9.0_disk1_2of2.zip -d ${_SCRATCH}/wcp && \
	rm -rf rm -rf ${_SCRATCH}/wcp/ofm_wc_generic_11.1.1.9.0_disk1_1of2.zip \
	${_SCRATCH}/wcp/ofm_wc_generic_11.1.1.9.0_disk1_2of2.zip && \
	${_SCRATCH}/wcp/Disk1/runInstaller -silent -invPtrLoc ${_SCRATCH}/oraInst.loc \
	-responseFile ${_SCRATCH}/wcp/Disk1/stage/Response/sampleResponse_wls.rsp -jreLoc ${JDK_HOME} \
	-waitforcompletion -force -novalidation MIDDLEWARE_HOME=${FMW_HOME} \
	ORACLE_HOME=${FMW_HOME}/Oracle_WC1 && \
	rm -rf ${_SCRATCH}/wcp/Disk* && \
	mkdir -p ${ADM_HOME}/tools/templates && \
	mkdir -p ${ADM_HOME}/tools/scripts && \
	cp ${_SCRATCH}/domain/* ${ADM_HOME}/tools/templates && \
	cp -r ${_SCRATCH}/scripts/* ${ADM_HOME}/tools/scripts && \
	rm -rf ${_SCRATCH}/domain ${_SCRATCH}/scripts && rm ${_SCRATCH}/jdk/jdk-7u91-linux-x64.tar.gz

RUN rm -rf ${_SCRATCH}

CMD /bin/bash
