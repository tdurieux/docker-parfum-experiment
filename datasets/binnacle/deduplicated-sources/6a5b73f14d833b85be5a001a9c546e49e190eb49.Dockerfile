# container for rsyslog development
# creates the build environment
FROM	ubuntu:18.04
ENV	DEBIAN_FRONTEND=noninteractive
RUN 	apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y \
	autoconf \
	autoconf-archive \
	automake \
	autotools-dev \
	bison \
	clang \
	clang-tools \
	curl \
	default-jdk \
	default-jre \
	faketime libdbd-mysql \
	flex \
	gcc \
	gcc-8 \
	gdb \
	git \
	libbson-dev \
	libcurl4-gnutls-dev \
	libdbi-dev \
	libgcrypt11-dev \
	libglib2.0-dev \
	libgnutls28-dev \
	libgrok1 libgrok-dev \
	libhiredis-dev \
	libkrb5-dev \
	liblz4-dev \
	libmaxminddb-dev libmongoc-dev \
	libmongoc-dev \
	libmysqlclient-dev \
	libnet1-dev \
	libpcap-dev \
	libsnmp-dev \
	libssl-dev libsasl2-dev \
	libsystemd-dev \
	libtokyocabinet-dev \
	libtool \
	libtool-bin \
	lsof \
	make \
	mysql-server \
	net-tools \
	pkg-config \
	postgresql-client libpq-dev \
	python-docutils  \
	python-pip \
	software-properties-common \
	sudo \
	uuid-dev \
	valgrind \
	vim \
	wget \
	zlib1g-dev
ENV	REBUILD=1
RUN	echo "deb http://download.opensuse.org/repositories/network:/messaging:/zeromq:/git-draft/xUbuntu_18.04/ ./" > /etc/apt/sources.list.d/0mq.list && \
	wget -nv -O - http://download.opensuse.org/repositories/network:/messaging:/zeromq:/git-draft/xUbuntu_18.04/Release.key | apt-key add - && \
 	add-apt-repository ppa:adiscon/v8-stable -y && \
	apt-get update -y && \
	apt-get install -y  \
	libczmq-dev \
	libqpid-proton8-dev \
	tcl-dev \
	libsodium-dev \
	libestr-dev \
	librelp-dev \
	libfastjson-dev \
	liblogging-stdlog-dev \
	liblognorm-dev
WORKDIR	/home/devel
VOLUME	/rsyslog
RUN	groupadd rsyslog \
	&& useradd -g rsyslog  -s /bin/bash rsyslog \
	&& echo "rsyslog ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
	&& echo "buildbot ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# mysql needs a little help:
RUN	mkdir -p /var/run/mysqld && \
	chown mysql:mysql /var/run/mysqld
ENV	MYSQLD_START_CMD="sudo mysqld_safe" \
        MYSQLD_STOP_CMD="sudo kill $(sudo cat /var/run/mysqld/mysqld.pid)"

ADD	setup-system.sh setup-system.sh
ENV	PKG_CONFIG_PATH=/usr/local/lib/pkgconfig \
	LD_LIBRARY_PATH=/usr/local/lib \
	DEBIAN_FRONTEND= \
	SUDO="sudo -S"

# Install any needed packages
RUN	./setup-system.sh

# other manual installs
# kafkacat
RUN	cd helper-projects \
	&& git clone https://github.com/edenhill/kafkacat \
	&& cd kafkacat \
	&& (unset CFLAGS; ./configure --prefix=/usr --CFLAGS="-g" ; make -j2) \
	&& make install \
	&& cd .. \
	&& cd ..
# Note: we do NOT delete the source as we may need it to
# uninstall (in case the user wants to go back to system-default)


# create dependency cache
RUN	mkdir /local_dep_cache && \
	wget -nv https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.6.9.tar.gz -O /local_dep_cache/elasticsearch-5.6.9.tar.gz  && \
	wget -nv https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.0.0.tar.gz -O /local_dep_cache/elasticsearch-6.0.0.tar.gz && \
	wget -nv https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.3.1.tar.gz -O /local_dep_cache/elasticsearch-6.3.1.tar.gz
# tell tests which are the newester versions, so they can be checked without the need
# to adjust test sources.
ENV	ELASTICSEARCH_NEWEST="elasticsearch-6.3.1.tar.gz"

# next ENV is specifically for running scan-build - so we do not need to
# change scripts if at a later time we can move on to a newer version
ENV	SCAN_BUILD=scan-build \
	SCAN_BUILD_CC=clang-6.0 \
	ASAN_SYMBOLIZER_PATH=/usr/lib/llvm-6.0/bin/llvm-symbolizer

ENV RSYSLOG_CONFIGURE_OPTIONS \
	--enable-elasticsearch \
	--enable-elasticsearch-tests \
	--enable-gnutls \
	--enable-gssapi-krb5 \
	--enable-imbatchreport \
	--enable-imczmq \
	--enable-imdiag \
	--enable-imfile \
	--enable-imjournal \
	--enable-imkafka \
	--enable-impcap \
	--enable-impstats \
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
	--enable-mmdblookup \
	--enable-mmfields \
	--enable-mmgrok \
	--enable-mmjsonparse \
	--enable-mmkubernetes \
	--enable-mmnormalize \
	--enable-mmpstrucdata \
	--enable-mmrm1stspace \
	--enable-mmsequence \
	--enable-mmsnmptrapd \
	--enable-mmutf8fix \
	--enable-mysql \
	--enable-mysql-tests \
	--enable-omamqp1 \
	--enable-omczmq \
	--enable-omhiredis \
	--enable-omhiredis \
	--enable-omhttpfs \
	--enable-omhttp \
	--enable-omjournal \
	--enable-omkafka \
	--enable-ommongodb \
	--enable-omprog \
	--enable-omrelp-default-port=13515 \
	--enable-omruleset \
	--enable-omstdout \
	--enable-omtcl \
	--enable-omudpspoof \
	--enable-omuxsock \
	--enable-openssl \
	--enable-pgsql \
	--enable-pmaixforwardedfrom \
	--enable-pmciscoios \
	--enable-pmdb2diag \
	--enable-pmcisconames \
	--enable-pmlastmsg \
	--enable-pmnormalize \
	--enable-pmnull \
	--enable-pmsnare \
	--enable-relp \
	--enable-snmp \
	--enable-usertools \
	--enable-valgrind \
	\
	--enable-testbench

# module needs fixes: --enable-kmsg
VOLUME	/var/lib/mysql
WORKDIR	/rsyslog
USER	rsyslog
