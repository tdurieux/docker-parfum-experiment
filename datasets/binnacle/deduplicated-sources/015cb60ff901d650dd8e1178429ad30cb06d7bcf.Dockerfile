FROM oracle/graalvm-ce:1.0.0-rc16

LABEL maintainer "MAIF <oss@maif.fr>"

RUN mkdir -p /otoroshi

WORKDIR /otoroshi

COPY ./otoroshi.jar /otoroshi
COPY ./entrypoint-graal.sh /otoroshi

RUN mkdir /otoroshi/conf \
  && mkdir /otoroshi/leveldb \
  && mkdir /otoroshi/imports

VOLUME /otoroshi/conf
VOLUME /otoroshi/imports
VOLUME /otoroshi/leveldb

RUN native-image -H:+ReportUnsupportedElementsAtRuntime --verbose --delay-class-initialization-to-runtime=play.api.Play$ -jar otoroshi.jar 

RUN ls -ahl

ENTRYPOINT ["./entrypoint-graal.sh"]

EXPOSE 8080

CMD [""]
