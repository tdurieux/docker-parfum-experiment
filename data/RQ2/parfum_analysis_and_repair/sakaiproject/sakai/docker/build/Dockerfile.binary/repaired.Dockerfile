FROM tomcat:9.0.20-jre8

ARG release=19.1

COPY lib/server.xml /usr/local/tomcat/conf/server.xml
COPY lib/context.xml /usr/local/tomcat/conf/context.xml
COPY lib/entrypoint.sh /entrypoint.sh

RUN mkdir /sakaibin && cd /sakaibin && wget https://source.sakaiproject.org/release/${release}/artifacts/sakai-bin-${release}.tar.gz && tar -zxvf sakai-bin-${release}.tar.gz && rm -fr /usr/local/tomcat/components && rm -fr /usr/local/tomcat/sakai-lib && rm -fr /usr/local/tomcat/webapps && cp -R /sakaibin/components /usr/local/tomcat/components/ && cp -R /sakaibin/lib /usr/local/tomcat/sakai-lib/ && cp -R /sakaibin/webapps /usr/local/tomcat/webapps/ && cd / && rm -fr /sakaibin && mkdir -p /usr/local/sakai/properties && sed -i '/^common.loader\=/ s/$/,"\$\{catalina.base\}\/sakai-lib\/*.jar"/' /usr/local/tomcat/conf/catalina.properties && curl -f -L -o /usr/local/tomcat/lib/mysql-connector-java-5.1.47.jar https://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.47/mysql-connector-java-5.1.47.jar && mkdir -p /usr/local/tomcat/sakai && chmod +x /entrypoint.sh && rm sakai-bin-${release}.tar.gz

ENV CATALINA_OPTS_MEMORY -Xms2000m -Xmx2000m
ENV CATALINA_OPTS \
-server \
-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+UseConcMarkSweepGC -XX:+UseParNewGC \
-XX:+CMSParallelRemarkEnabled -XX:+UseCompressedOops -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=80 -XX:TargetSurvivorRatio=90 \
-Djava.awt.headless=true \
-Dsun.net.inetaddr.ttl=0 \
-Dsakai.component.shutdownonerror=true \
-Duser.language=en -Duser.country=US \
-Dsakai.home=/usr/local/sakai/properties -Dsakai.security=/usr/local/tomcat/sakai \
-Duser.timezone=US/Eastern \
-Dsun.net.client.defaultConnectTimeout=300000 \
-Dsun.net.client.defaultReadTimeout=1800000 \
-Dorg.apache.jasper.compiler.Parser.STRICT_QUOTE_ESCAPING=false \
-Dsun.lang.ClassLoader.allowArraySyntax=true \
-Dhttp.agent=Sakai \
-Djava.util.Arrays.useLegacyMergeSort=true

ENTRYPOINT ["/entrypoint.sh"]
