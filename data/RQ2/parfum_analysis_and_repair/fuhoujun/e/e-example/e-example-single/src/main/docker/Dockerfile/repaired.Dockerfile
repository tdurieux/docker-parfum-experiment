FROM java:8
ADD *.jar e-example-single.jar
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-Dfile.encoding=UTF-8","-jar","/e-example-single.jar"]