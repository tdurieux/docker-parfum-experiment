FROM openjdk:11-jdk-buster

RUN apt-get update && apt-get install --no-install-recommends -y maven && rm -rf /var/lib/apt/lists/*;

COPY releng /jmc/releng/

WORKDIR /jmc/releng/third-party
RUN mvn p2:site
CMD mvn jetty:run
