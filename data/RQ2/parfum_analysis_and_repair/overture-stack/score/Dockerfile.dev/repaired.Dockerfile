###############################
# Score Client
###############################
FROM ubuntu:18.04 as client

ENV CLIENT_DIST_DIR    /score-client-dist
ENV JDK_DOWNLOAD_URL https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz
ENV SCORE_CLIENT_HOME /score-client
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$SCORE_CLIENT_HOME/bin
ENV SCORE_USER score

# Add score user, update apt, add FUSE support and basic command line tools
RUN useradd $SCORE_USER  \
  	&& apt-get update \
  	&& apt-get -y upgrade \
    && apt-get install --no-install-recommends -y libfuse-dev fuse curl wget software-properties-common \
	&& mkdir $SCORE_CLIENT_HOME && rm -rf /var/lib/apt/lists/*;


COPY score-client/target/score-client-*-dist.tar.gz  /score-client.tar.gz

# Install Open JDK 11, and remove unused things at runtime
RUN mkdir /usr/lib/jvm \
	&& cd /usr/lib/jvm \
	&& wget $JDK_DOWNLOAD_URL -O openjdk11.tar.gz \
    && tar zxvf openjdk11.tar.gz \
	&& rm -rf openjdk11.tar.gz \
	&& echo 'PATH=$PATH:/usr/lib/jvm/jdk-11/bin' >> /etc/environment \
	&& echo 'JAVA_HOME=/usr/lib/jvm/jdk-11' >> /etc/environment \
	&& rm -rf /usr/lib/jvm/jdk-11/jmods \
	&& rm -rf /usr/lib/jvm/jdk-11/lib/src.zip \
	&& update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk-11/bin/java" 0 \
	&& update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk-11/bin/javac" 0 \
	&& update-alternatives --set java /usr/lib/jvm/jdk-11/bin/java \
	&& update-alternatives --set javac /usr/lib/jvm/jdk-11/bin/javac \
	&& update-alternatives --list java \
	&& update-alternatives --list javac \
	&& java -version

RUN tar zxvf score-client.tar.gz -C /tmp \
	&& rm -rf score-client.tar.gz \
    && mv -f /tmp/score-client-*  /tmp/score-client-dist  \
    && cp -r /tmp/score-client-dist $CLIENT_DIST_DIR \
	&& mkdir -p $CLIENT_DIST_DIR/logs \
	&& touch $CLIENT_DIST_DIR/logs/client.log \
	&& chmod 777 $CLIENT_DIST_DIR/logs/client.log \
	&& mkdir -p $SCORE_CLIENT_HOME \
	&& mv $CLIENT_DIST_DIR/* $SCORE_CLIENT_HOME  \
	&& chown -R $SCORE_USER:$SCORE_USER $SCORE_CLIENT_HOME

# Set working directory for convenience with interactive usage
WORKDIR $SCORE_CLIENT_HOME

###############################
# Score Server
###############################
FROM adoptopenjdk/openjdk11:jre-11.0.6_10-alpine as server

# Paths
ENV SCORE_HOME /score-server
ENV SCORE_LOGS $SCORE_HOME/logs
ENV JAR_FILE    /score-server.jar
ENV SCORE_USER score
ENV SCORE_UID 9999
ENV SCORE_GID 9999

RUN addgroup -S -g $SCORE_GID $SCORE_USER  \
    && adduser -S -u $SCORE_UID -G $SCORE_USER $SCORE_USER  \
    && mkdir $SCORE_HOME $SCORE_LOGS \
    && chown -R $SCORE_UID:$SCORE_GID $SCORE_HOME

# Prepare server jar
COPY score-server/target/score-server-*-dist.tar.gz  /score-server.tar.gz

RUN tar zxvf score-server.tar.gz -C /tmp \
    && mv -f /tmp/score-server-*  /tmp/score-server-dist  \
    && cp -f /tmp/score-server-dist/lib/score-server.jar $JAR_FILE \
	&& rm -rf /score-server.tar.gz

USER $SCORE_UID

WORKDIR $SCORE_HOME

CMD java -Dlog.path=$SCORE_LOGS \
    -jar $JAR_FILE \
    --spring.config.location=classpath:/application.yml,classpath:/bootstrap.properties

