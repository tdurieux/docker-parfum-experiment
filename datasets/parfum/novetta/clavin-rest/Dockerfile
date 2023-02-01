FROM adoptopenjdk/openjdk14:centos
RUN mkdir /opt/clavin-rest
RUN mkdir /opt/clavin-rest/IndexDirectory
COPY target/clavin-rest.jar /opt/clavin-rest
ADD IndexDirectory.tar.gz /opt/clavin-rest
EXPOSE 9090/tcp
WORKDIR "/opt/clavin-rest"
CMD ["java", "-jar", "clavin-rest.jar"]
