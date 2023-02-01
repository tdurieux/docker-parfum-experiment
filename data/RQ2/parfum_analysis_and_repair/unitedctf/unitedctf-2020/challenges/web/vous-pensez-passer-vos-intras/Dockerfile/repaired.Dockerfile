FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y --no-install-recommends install maven mysql-server && rm -rf /var/lib/apt/lists/*;

COPY ./ /tmp/src
WORKDIR /tmp/src
RUN mvn clean install
EXPOSE 8080

ENTRYPOINT ["bash", "run.sh"]
