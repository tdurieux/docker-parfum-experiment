FROM oracle/webcenter/portal:11.1.1.9.0
MAINTAINER Justin Paul <justin.paul@oracle.com>

COPY wls wcp ${_SCRATCH}/patches/

USER root

RUN yum update -y -q && \
	chown -R oracle:oinstall ${_SCRATCH}

USER oracle

RUN mkdir -p ${FMW_HOME}/utils/bsu/cache_dir && \
	unzip -qq ${_SCRATCH}/patches/p20780171_1036_Generic.zip -d ${FMW_HOME}/utils/bsu/cache_dir && \
	cd ${FMW_HOME}/utils/bsu && \
	sed -i 's/-Xmx512m/-Xmx1024m/g' ${FMW_HOME}/utils/bsu/bsu.sh && \
	${FMW_HOME}/utils/bsu/bsu.sh -prod_dir=${FMW_HOME}/wlserver_10.3 -patchlist=EJUW -verbose -install && \
	rm -rf ${_SCRATCH}/patches/p20780171_1036_Generic.zip && \
	cd && \
	unzip -qq ${_SCRATCH}/patches/p21950042_111190_Generic.zip -d ${_SCRATCH}/patches && \
	${FMW_HOME}/oracle_common/OPatch/opatch apply -silent ${_SCRATCH}/patches/21950042 && \
	${FMW_HOME}/Oracle_WC1/OPatch/opatch apply -silent ${_SCRATCH}/patches/21950042 && \
	rm -rf ${_SCRATCH}/patches/p21950042_111190_Generic.zip ${_SCRATCH}/patches/21950042

RUN rm -rf ${_SCRATCH}

CMD /bin/bash