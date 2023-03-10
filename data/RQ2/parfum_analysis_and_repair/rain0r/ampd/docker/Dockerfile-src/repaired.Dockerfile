FROM maven:3-jdk-11 as builder
ARG frontend_context=/
WORKDIR /srv
COPY . .
ENV DEBIAN_FRONTEND=noninteractive
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN mvn package -q -Dfrontend.context=$frontend_context

FROM openjdk:11-jre-slim
WORKDIR /srv
COPY --from=builder /srv/target/ampd-*.jar ./ampd.jar
EXPOSE 8080

CMD ["java", "-jar", "ampd.jar"]
