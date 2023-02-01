FROM cnrireami/getit:sos-4.4.2
MAINTAINER Starterkit development team

# Project: https://github.com/52North/sos

RUN apt-get -y --no-install-recommends install netcat \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY sos-config/configuration.db $CATALINA_HOME/webapps/observations/
COPY sos-config/datasource.properties $CATALINA_HOME/webapps/observations/WEB-INF
RUN  cp $CATALINA_HOME/webapps/observations/WEB-INF/web.xml $CATALINA_HOME/webapps/observations/WEB-INF/web.xml.orig
COPY tomcat-bin/web-observations.xml $CATALINA_HOME/webapps/observations/WEB-INF/web.xml
COPY tomcat-bin/web-conf.xml $CATALINA_HOME/conf/web.xml
COPY tomcat-bin/setenv.sh $CATALINA_HOME/bin
COPY tomcat-bin/index.html $CATALINA_HOME/webapps/ROOT
#COPY tomcat-bin/observations.xml $CATALINA_HOME/conf/Catalina/localhost

# install python and pip
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install --no-install-recommends -y python python-pip python-dev \
    && apt-get install --no-install-recommends -y postgresql-client && rm -rf /var/lib/apt/lists/*;

COPY sos-config/requirements.txt /tmp
COPY sos-config/entrypoint.sh /tmp
COPY sos-config/tasks.py /tmp

RUN pip install --no-cache-dir pip==9.0.3 \
    && pip install --no-cache-dir -r requirements.txt \
    && chmod +x $CATALINA_HOME/bin/*.sh \
    && chmod +x /tmp/entrypoint.sh \
    && chmod +x /tmp/tasks.py

# NetCDF library for get observation
RUN apt-get install --no-install-recommends -y libnetcdf-dev libnetcdff-dev && rm -rf /var/lib/apt/lists/*;

CMD ["/tmp/entrypoint.sh"]
