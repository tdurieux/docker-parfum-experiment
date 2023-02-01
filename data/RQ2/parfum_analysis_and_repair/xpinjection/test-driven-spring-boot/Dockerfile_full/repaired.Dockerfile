FROM maven:3.8.4-jdk-17 AS maven_dependencies
COPY pom.xml /tmp/
RUN mvn -B dependency:go-offline -f /tmp/pom.xml -s /usr/share/maven/ref/settings-docker.xml

FROM maven_dependencies as maven_build
COPY src /tmp/src/
COPY .git /tmp/.git/
COPY lombok.config /tmp/
WORKDIR /tmp/
RUN mvn -B -s /usr/share/maven/ref/settings-docker.xml package -DskipTests
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} library.jar
RUN java -Djarmode=layertools -jar library.jar extract

FROM openjdk:17.0.2-slim
VOLUME /tmp
COPY --from=maven_build dependencies/ ./
COPY --from=maven_build snapshot-dependencies/ ./
COPY --from=maven_build spring-boot-loader/ ./
COPY --from=maven_build application/ ./
ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]