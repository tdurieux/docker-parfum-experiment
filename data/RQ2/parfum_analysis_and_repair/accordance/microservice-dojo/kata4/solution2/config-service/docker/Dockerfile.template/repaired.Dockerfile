FROM java:8
MAINTAINER Igor Moochnick "igor@igorshare.com"
VOLUME /tmp
EXPOSE 8888
ADD ${jar.baseName}-${jar.version}.jar ${project.name}.jar
# RUN bash -c 'touch /${project.name}.jar'
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom" ,"-jar", "/${project.name}.jar" ]