FROM ubuntu:18.04
RUN apt-get update -qqy && apt-get install --no-install-recommends -qqy openjdk-11-jre-headless && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT exec java -classpath "/fixture/shared/*" fixture.azure.AzureHttpFixture 0.0.0.0 8091 container
EXPOSE 8091
