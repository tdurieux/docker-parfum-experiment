FROM dremio/dremio-oss:17.0.0
USER root

WORKDIR /tmp

RUN wget https://apache.osuosl.org/maven/maven-3/3.6.1/binaries/apache-maven-3.6.1-bin.zip && \
	unzip apache-maven-3.6.1-bin.zip && \
	git clone https://github.com/narendrans/dremio-snowflake.git && cd dremio-snowflake && \
	export PATH=$PATH:/tmp/apache-maven-3.6.1/bin && \
	mvn clean install -DskipTests && \
	cp target/dremio-snowflake*.jar /opt/dremio/jars && \
	cd /opt/dremio/jars && wget https://repo1.maven.org/maven2/net/snowflake/snowflake-jdbc/3.13.5/snowflake-jdbc-3.13.5.jar && \
	chown dremio *snowflake*.jar && rm -rf ~/.m2 && rm -rf /tmp/*

WORKDIR /opt/dremio
USER dremio
