FROM jhipster/jhipster:latest
USER root
ADD . /code/
RUN rm -Rf /code/target /code/build /code/node_modules && \
    cd /code/ && \
  <%_ if (buildTool === 'maven') { _%>
    ./mvnw clean package -Pprod -DskipTests && \
    mv /code/target/*.war /app.war
  <%_ } else if (buildTool === 'gradle') { _%>
    ./gradlew -Pprod bootWar -x test && \
    mv /code/build/libs/*.war /app.war
  <%_ } _%>

FROM openjdk:8-jre-alpine
ENV SPRING_OUTPUT_ANSI_ENABLED=ALWAYS \
    JHIPSTER_SLEEP=0 \
    JAVA_OPTS=""
EXPOSE <%= serverPort %><% if (cacheProvider === 'hazelcast') { %> 5701/udp<% } %>
CMD echo "The application will start in ${JHIPSTER_SLEEP}s..." && \
    sleep ${JHIPSTER_SLEEP} && \
    java ${JAVA_OPTS} -Djava.security.egd=file:/dev/./urandom -jar /app.war
COPY --from=0 /app.war .