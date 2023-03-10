FROM jetty:9-jre11

ENV XMS=1536M XMX=8G

RUN java -jar "$JETTY_HOME/start.jar" --create-startd --add-to-start=jmx,jmx-remote,stats,jndi,http-forwarded

COPY --chown=jetty:jetty . /

USER root

RUN echo "deb http://httpredir.debian.org/debian buster main contrib" > /etc/apt/sources.list \
    && echo "deb http://security.debian.org/ buster/updates main contrib" >> /etc/apt/sources.list \
    && echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections \
    && apt-get update \
    && apt-get install --no-install-recommends -y ttf-mscorefonts-installer \
    && apt-get install --no-install-recommends -y wget \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://downloads.sourceforge.net/project/libjpeg-turbo/2.0.5/libjpeg-turbo-official_2.0.5_amd64.deb \
    && dpkg -i libjpeg-turbo-official_2.0.5_amd64.deb \
    && apt-get -f -y install \
    && rm libjpeg-turbo-official_2.0.5_amd64.deb

RUN mkdir /mnt/geoserver_datadir /mnt/geoserver_geodata /mnt/geoserver_tiles /mnt/geoserver_native_libs && \
    chown jetty:jetty /etc/georchestra /mnt/geoserver_datadir /mnt/geoserver_geodata /mnt/geoserver_tiles /mnt/geoserver_native_libs

# add a tweaked configuration. First use case is support of OPTIONS.
ADD web.xml /var/lib/jetty/webapps/geoserver/WEB-INF/web.xml

USER jetty

VOLUME [ "/mnt/geoserver_datadir", "/mnt/geoserver_geodata", "/mnt/geoserver_tiles", "/mnt/geoserver_native_libs", "/tmp", "/run/jetty" ]

ENTRYPOINT [ "/docker-entrypoint.sh" ]

ENV LD_LIBRARY_PATH=/mnt/geoserver_native_libs:/opt/libjpeg-turbo/lib64

CMD ["sh", "-c", "exec java -Djava.io.tmpdir=/tmp/jetty \
-Dgeofence-ovr=file:/etc/georchestra/geoserver/geofence/geofence-datasource-ovr.properties \
-Dgeorchestra.datadir=/etc/georchestra \
-DGEOSERVER_DATA_DIR=/mnt/geoserver_datadir \
-DGEOWEBCACHE_CACHE_DIR=/mnt/geoserver_tiles \
-DENABLE_JSONP=true \
-Ds3.caching.ehCacheConfig=/etc/georchestra/geoserver/s3-geotiff/s3-geotiff-ehcache.xml \
-Ds3.properties.location=/etc/georchestra/geoserver/s3-geotiff/s3.properties \
-Dhttps.protocols=TLSv1,TLSv1.1,TLSv1.2 \
-Xms$XMS -Xmx$XMX \
-XX:SoftRefLRUPolicyMSPerMB=36000 \
-XX:-UsePerfData \
${JAVA_OPTIONS} \
-Djetty.httpConfig.sendServerVersion=false \
-Djetty.jmxremote.rmiregistryhost=0.0.0.0 \
-Djetty.jmxremote.rmiserverhost=0.0.0.0 \
-jar /usr/local/jetty/start.jar" ]

ARG GS_VERSION
ENV GS_VERSION=$GS_VERSION
