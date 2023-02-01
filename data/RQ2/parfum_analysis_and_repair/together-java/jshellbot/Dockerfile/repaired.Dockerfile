FROM openjdk:11-jdk-slim

RUN apt-get update && apt-get -y --no-install-recommends install gettext-base dumb-init && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt/app
COPY target .
COPY etc/_example.bot.properties .
ARG token
ENV TOKEN=$token
RUN envsubst '${TOKEN}' < _example.bot.properties > bot.properties && rm _example.bot.properties && chmod 400 bot.properties
RUN chmod +x JShellBot.jar

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["java", "-jar", "JShellBot.jar"]



