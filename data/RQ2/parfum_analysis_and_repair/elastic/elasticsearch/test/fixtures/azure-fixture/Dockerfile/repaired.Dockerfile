FROM ubuntu:20.04
RUN apt-get update -qqy && apt-get install --no-install-recommends -qqy openjdk-17-jre-headless && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT exec java -classpath "/fixture/shared/*" fixture.azure.AzureHttpFixture 0.0.0.0 8091 azure_integration_test_account container
EXPOSE 8091
