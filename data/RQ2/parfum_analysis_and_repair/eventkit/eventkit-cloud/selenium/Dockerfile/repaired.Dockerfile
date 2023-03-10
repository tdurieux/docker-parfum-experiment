FROM selenium/standalone-chrome:3.141.59

USER root

WORKDIR /var/lib/eventkit/selenium

RUN apt-get update && apt-get install --no-install-recommends -y maven openjdk-8-jdk-headless && apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY --chown=root ./ /var/lib/eventkit/selenium

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

CMD ['mvn', 'clean', 'test']