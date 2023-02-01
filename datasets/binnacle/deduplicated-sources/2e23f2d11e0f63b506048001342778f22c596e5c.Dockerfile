# container for rsyslog development
# creates the build environment
# to search for packages:
# note: czmq OBS link: https://build.opensuse.org/package/show/network:messaging:zeromq:release-stable/czmq
# 1. zypper search
# 2. scout bin which  # scout need zypper install scout - then call "scout" for usage
FROM	opensuse/tumbleweed
RUN 	zypper --non-interactive update
RUN	zypper --non-interactive install \
	autoconf \
	autoconf-archive \
	automake \
	bison \
	clang \
	cmake \
	curl \
	flex \
	gcc \
	gdb \
	git \
	gzip \
	hiredis-devel \
	java-11-openjdk-devel \
	krb5-devel \
	libcurl-devel \
	libczmq4 \
	libdbi-devel \
	libdbi-drivers-dbd-mysql \
	libestr-devel \
	libfaketime \
	libgcrypt-devel \
	libgnutls-devel \
	libmaxminddb-devel \
	libmysqlclient-devel \
	libnet-devel \
	libopenssl-devel \
	libpcap-devel \
	libqpid-proton10 \
	libtool \
	libuuid-devel \
	make \
	net-snmp-devel \
	pcre-devel \
	postgresql-devel \
	python3-docutils \
	python-devel \
	python-docutils \
	python-sphinx \
	qpid-proton \
	qpid-proton-devel \
	systemd-devel \
	tcl-devel \
	util-linux-systemd \
	valgrind \
	vi \
	wget \
	which \
	zlib-devel
RUN	zypper --non-interactive addrepo https://download.opensuse.org/repositories/network:messaging:zeromq:release-stable/openSUSE_Tumbleweed/network:messaging:zeromq:release-stable.repo && \
	zypper --non-interactive --gpg-auto-import-keys refresh && \
	zypper --non-interactive install \
	openpgm-devel \
	czmq \
	czmq-devel

ENV	REBUILD=1
WORKDIR /home/devel
RUN	groupadd rsyslog && \
	useradd -g rsyslog  -s /bin/bash rsyslog && \
	echo "rsyslog ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN	mkdir /rsyslog && \
	chown rsyslog:rsyslog /rsyslog
VOLUME /rsyslog
ADD	setup-projects.sh setup-projects.sh
ENV	PKG_CONFIG_PATH=/usr/lib/pkgconfig \
	xLD_LIBRARY_PATH=/usr/local/lib 

# create dependency cache
RUN	mkdir /local_dep_cache && \
	wget -nv https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.6.9.tar.gz -O /local_dep_cache/elasticsearch-5.6.9.tar.gz  && \
	wget -nv https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.0.0.tar.gz -O /local_dep_cache/elasticsearch-6.0.0.tar.gz && \
	wget -nv https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.3.1.tar.gz -O /local_dep_cache/elasticsearch-6.3.1.tar.gz
# tell tests which are the newester versions, so they can be checked without the need
# to adjust test sources.
ENV	ELASTICSEARCH_NEWEST="elasticsearch-6.3.1.tar.gz"

# bump dependency version below to trigger a dependency rebuild
# but not a full one (via --no-cache)
ENV	DEP_VERSION=1
# Helper projects and dependency build starts here
RUN	mkdir helper-projects
# code style checker - not yet packaged
RUN	cd helper-projects && \
	git clone https://github.com/rsyslog/codestyle && \
	cd codestyle && \
	gcc --std=c99 stylecheck.c -o stylecheck && \
	mv stylecheck /usr/bin/rsyslog_stylecheck && \
	cd .. && \
	rm -r codestyle && \
	cd ..

# we need Guardtime libksi here, otherwise we cannot check the KSI component	
RUN	cd helper-projects && \
	git clone https://github.com/guardtime/libksi.git && \
	cd libksi && \
	autoreconf -fvi && \
	./configure --libdir=/usr/lib64 && \
	make -j2 && \
	make install && \
	cd .. && \
	rm -r libksi && \
	cd ..

# we need the latest librdkafka as there as always required updates
RUN	cd helper-projects && \
	git clone https://github.com/edenhill/librdkafka && \
	cd librdkafka && \
	(unset CFLAGS; ./configure --prefix=/usr --libdir=/usr/lib64 --CFLAGS="-g" ; make -j) && \
	make install && \
	cd .. && \
# Note: we do NOT delete the source as we may need it to
# uninstall (in case the user wants to go back to system-default)
	cd ..

# libmongoc is unfortunately not available on openSuse - later?
RUN	cd helper-projects && \
	wget -nv https://github.com/mongodb/mongo-c-driver/releases/download/1.12.0/mongo-c-driver-1.12.0.tar.gz && \
	tar xzf mongo-c-driver-1.12.0.tar.gz && \
	cd mongo-c-driver-1.12.0 && \
	mkdir cmake-build && \
	cmake -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF && \
	make -j4 && \
	make install && \
	cd .. && \
	rm -r mongo-c-driver-1.12.0* && \
	cd ..

# bump dependency version below to trigger a dependency rebuild
# but not a full one (via --no-cache)
ENV	RSYSLOG_DEP_VERSION=2018-07-22

# libestr - currently, not needed, we use from offical repo (unlikely to change)
#RUN	cd helper-projects && \
#	git clone https://github.com/rsyslog/libestr.git && \
#	cd libestr && \
#	autoreconf -fi && ./configure --libdir=/usr/lib64 --prefix=/usr && \
#	make -j4 && \
#	make install && \
#	cd .. && \
#	rm -r libestr && \
#	cd ..

# liblogging
RUN	cd helper-projects && \
	git clone https://github.com/rsyslog/liblogging.git && \
	cd liblogging && \
	autoreconf -fi && \
	./configure --prefix=/usr --libdir=/usr/lib64 --disable-journal && \
	make -j4 && \
	make install && \
	cd .. && \
	rm -r liblogging && \
	cd ..

# liblfastjson
RUN	cd helper-projects && \
	git clone https://github.com/rsyslog/libfastjson.git && \
	cd libfastjson && \
	autoreconf -fi && \
	./configure --prefix=/usr --libdir=/usr/lib64 && \
	make -j4 && \
	make install && \
	cd .. && \
	rm -r libfastjson && \
	cd ..

# liblognorm
RUN	cd helper-projects && \
	git clone https://github.com/rsyslog/liblognorm.git && \
	cd liblognorm && \
	autoreconf -fi && \
	./configure --prefix=/usr --libdir=/usr/lib64 && \
	make -j4 && \
	make install && \
	cd .. && \
	rm -r liblognorm && \
	cd ..

# librelp
RUN	cd helper-projects && \
	git clone https://github.com/rsyslog/librelp.git && \
	cd librelp && \
	autoreconf -fi && \
	./configure --prefix=/usr --enable-compile-warnings=yes --libdir=/usr/lib64 && \
	make -j4 && \
	make install && \
	cd .. && \
	rm -r librelp && \
	cd ..

# next ENV is specifically for running scan-build - so we do not need to
# change scripts if at a later time we can move on to a newer version
ENV	SCAN_BUILD=scan-build \
	SCAN_BUILD_CC=clang-6.0

# unfortunately, tcl-devel does not properly setup required bits in the environment
# so we now try to do that. In case this does no longer work with a version, search
# for a file tclConfig.sh, which should be present in the library directory (usually
# beneath /usr). It contains the environment variables. Inside container do:
# $cat $(find /usr -name tclConfig.sh|head -n1)
ENV	TCL_LIB_SPEC="-L/usr/lib64 -ltcl8.6" \
	TCL_INCLUDE_SPEC=-I/usr/include

ENV RSYSLOG_CONFIGURE_OPTIONS \
	--enable-elasticsearch \
	--enable-elasticsearch-tests \
	--enable-gnutls \
	--enable-imbatchreport \
	--enable-imdiag \
	--enable-imdocker \
	--enable-imfile \
	--enable-imjournal \
	--enable-imkafka \
	--enable-impstats \
	--enable-impcap \
	--enable-imptcp \
	--enable-imtuxedoulog \
	--enable-kafka-tests \
	--enable-ksi-ls12 \
	--enable-libdbi \
	--enable-libfaketime \
	--enable-libgcrypt \
	--enable-mail \
	--enable-mmanon \
	--enable-mmaudit \
	--enable-mmcount \
	--enable-mmcapture \
	--enable-mmfields \
	--enable-mmjsonparse \
	--enable-mmkubernetes \
	--enable-mmnormalize \
	--enable-mmpstrucdata \
	--enable-mmrm1stspace \
	--enable-mmsequence \
	--enable-mmsnmptrapd \
	--enable-mmutf8fix \
	--enable-mysql \
	--enable-omamqp1 \
	--enable-omhiredis \
	--enable-omhiredis \
	--enable-omhttp \
	--enable-omhttpfs \
	--enable-omjournal \
	--enable-omkafka \
	--enable-omprog \
	--enable-omrelp-default-port=13515 \
	--enable-omruleset \
	--enable-omstdout \
	--enable-omudpspoof \
	--enable-omuxsock \
	--enable-openssl \
	--enable-pgsql \
	--enable-pmaixforwardedfrom \
	--enable-pmciscoios \
	--enable-pmcisconames \
	--enable-pmlastmsg \
	--enable-pmnormalize \
	--enable-pmnull \
	--enable-pmsnare \
	--enable-relp \
	--enable-snmp \
	--enable-usertools \
	--enable-valgrind \
	--enable-gssapi-krb5 \
	--enable-omtcl \
	--enable-imczmq \
	--enable-omczmq \
	--enable-mmdblookup \
	--enable-kmsg \
	--enable-ommongodb \
	\
	--enable-testbench

# module needs fixes:
#	--enable-mmgrok
#	   -> we cannot build, libtokyocabinet dependency is not available as well
WORKDIR /rsyslog
USER rsyslog
