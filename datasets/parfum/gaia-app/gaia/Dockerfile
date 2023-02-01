FROM maven:3-eclipse-temurin-17 as BUILD

COPY . /usr/src/app
RUN mvn --batch-mode -DskipTests -f /usr/src/app/pom.xml clean package

FROM eclipse-temurin:17
EXPOSE 8080
COPY --from=BUILD /usr/src/app/target/*.jar /opt/target/gaia.jar
WORKDIR /opt/target

ENV JDK_JAVA_OPTIONS "--add-exports java.naming/com.sun.jndi.ldap=ALL-UNNAMED"

CMD ["java", "-jar", "gaia.jar"]
