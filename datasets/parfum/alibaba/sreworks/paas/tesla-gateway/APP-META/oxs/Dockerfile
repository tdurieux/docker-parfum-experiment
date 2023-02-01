FROM reg.docker.alibaba-inc.com/abm-aone/maven:alios7u2min-ajdk-8-3.6.3 AS build
COPY . /app
RUN cd /app && mvn -Dmaven.test.skip=true clean package -U

FROM reg.docker.alibaba-inc.com/abm-aone/jdk:alios7u2min-ajdk-8 AS release
ARG START_MODULE=tesla-gateway-start-private
ARG TARGET_DIRECTORY=tesla-gateway
ARG DEPENDENCY=/app/${START_MODULE}/target/${TARGET_DIRECTORY}

COPY --from=build ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=build ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=build ${DEPENDENCY}/BOOT-INF/classes /app
COPY build/start.sh /app/sbin/start.sh
RUN mv /app/application-docker.yml /app/application.yml
ENTRYPOINT ["/app/sbin/start.sh"]