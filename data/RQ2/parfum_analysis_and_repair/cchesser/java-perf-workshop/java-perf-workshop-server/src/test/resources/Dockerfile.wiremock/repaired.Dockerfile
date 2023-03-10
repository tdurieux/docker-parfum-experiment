FROM openjdk:8
RUN wget https://repo1.maven.org/maven2/com/github/tomakehurst/wiremock-standalone/2.27.2/wiremock-standalone-2.27.2.jar -O wiremock-standalone.jar
COPY __files/ /data/__files/
COPY mappings/ /data/mappings/
CMD java -jar wiremock-standalone.jar --root-dir /data/