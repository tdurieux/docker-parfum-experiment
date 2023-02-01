FROM aitusoftware/babl:latest

RUN mkdir /babl/server
RUN chown babl:users /babl/server
COPY docker/application_container/lib/ /babl/lib/
COPY docker/application_container/config/application.properties /babl/config/
ENV BABL_CONFIG_FILE="/babl/config/application.properties"
ENV JVM_CLASSPATH_APPEND=":/babl/lib/"
ENV JVM_RUNTIME_PARAMETERS="-Dbabl.debug.enabled=false"
