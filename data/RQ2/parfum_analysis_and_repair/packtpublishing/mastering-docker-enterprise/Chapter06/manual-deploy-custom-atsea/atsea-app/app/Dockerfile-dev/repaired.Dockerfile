FROM node:latest As jsbuild
WORKDIR /usr/src/atsea/app/react-app
COPY react-app .
RUN npm install && npm cache clean --force;
RUN npm run build

FROM maven:latest As maven
WORKDIR /usr/src/atsea
COPY pom.xml .
RUN mvn -B -f pom.xml -s /usr/share/maven/ref/settings-docker.xml dependency:resolve
COPY . .
RUN mvn -B -s /usr/share/maven/ref/settings-docker.xml package -DskipTests

FROM java:8-jdk-alpine
WORKDIR /static
COPY --from=jsbuild /usr/src/atsea/app/react-app/build/ .
WORKDIR /app
COPY --from=maven /usr/src/atsea/target/AtSea-0.0.1-SNAPSHOT.jar .
EXPOSE 5005
ENTRYPOINT ["java", "-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5005","-jar", "/app/AtSea-0.0.1-SNAPSHOT.jar"]
CMD ["--spring.profiles.active=postgres"]
