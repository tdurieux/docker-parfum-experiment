FROM postgres:9.5  
MAINTAINER Mike Dillon <mike@appropriate.io>  
  
ENV POSTGIS_MAJOR 2.3  
#ENV POSTGIS_VERSION 2.3.2+dfsg-1~exp2.pgdg80+1  
RUN apt-get update \  
&& apt-get install -y --no-install-recommends \  
postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR \  
postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR-scripts \  
postgis \  
&& rm -rf /var/lib/apt/lists/*  
#RUN apt-get install -y --no-install-recommends \  
# postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR=$POSTGIS_VERSION \  
# postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR-scripts=$POSTGIS_VERSION \  
# postgis=$POSTGIS_VERSION \  
# && rm -rf /var/lib/apt/lists/*  
RUN mkdir -p /docker-entrypoint-initdb.d  
COPY ./initdb-postgis.sh /docker-entrypoint-initdb.d/postgis.sh  
COPY ./update-postgis.sh /usr/local/bin  
  

