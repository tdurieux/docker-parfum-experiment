FROM oraclelinux:6
MAINTAINER Justin Paul <justin.paul@oracle.com>

ENV _SCRATCH /tmp/scratch
ENV PASSWORD welcome1

COPY xe/oracle-xe-11.2.0-1.0.x86_64.rpm.zip ${_SCRATCH}/db/

RUN yum update -y -q && \
	yum install -y -q binutils compat-libcap1 compat-libstdc++-33 \
	compat-libstdc++-33.i686 gcc gcc-c++ glibc glibc-devel glibc-devel.i686 \
	libaio libaio-devel libgcc libgcc.i686 libstdc++ libstdc++.i686 \
	libstdc++-devel libXext libXtst libXi openmotif openmotif22 redhat-lsb \
	sysstat zlib zlib.i686 libX11 libX11.i686 unzip xorg-x11-utils xorg-x11-xauth && rm -rf /var/cache/yum

RUN unzip -qq ${_SCRATCH}/db/oracle-xe-11.2.0-1.0.x86_64.rpm.zip -d ${_SCRATCH}/db && \
	rpm -ivh ${_SCRATCH}/db/Disk1/oracle-xe-11.2.0-1.0.x86_64.rpm && \
	sed -i "s/ORACLE_PASSWORD=<value required>/ORACLE_PASSWORD=${PASSWORD}/g" \
	${_SCRATCH}/db/Disk1/response/xe.rsp && \
	sed -i "s/ORACLE_CONFIRM_PASSWORD=<value required>/ORACLE_CONFIRM_PASSWORD=${PASSWORD}/g" \
	${_SCRATCH}/db/Disk1/response/xe.rsp && \
	/etc/init.d/oracle-xe configure responseFile=${_SCRATCH}/db/Disk1/response/xe.rsp

RUN rm -rf ${_SCRATCH}

CMD /etc/init.d/oracle-xe start && /bin/bash
