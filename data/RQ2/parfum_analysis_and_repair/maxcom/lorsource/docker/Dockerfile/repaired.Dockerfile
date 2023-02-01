# Не собирается с помощью maven:3.6-jdk-8-slim, поэтому используем 11.
FROM maven:3.6-jdk-11-slim as builder

RUN apt-get update && apt-get upgrade -y

RUN adduser --system --shell /bin/false --home /opt/lorsource lorsource
USER lorsource
WORKDIR /opt/lorsource

# Кэшируем зависимости Maven.