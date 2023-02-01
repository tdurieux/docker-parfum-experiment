FROM livingobjects/jre8
VOLUME /tmp
ADD main-data-provider-1.0-SNAPSHOT.jar app.jar
ADD wait-for-it.sh /wait-for-it.sh
RUN bash -c 'touch /app.jar'
RUN chmod +x /wait-for-it.sh
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
EXPOSE 18002