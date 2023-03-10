FROM ubuntu:20.04

RUN apt-get update -qqy && apt-get install --no-install-recommends -qqy openjdk-17-jre-headless && rm -rf /var/lib/apt/lists/*;

ARG port
ARG workingDir
ARG repositoryDir

ENV URL_FIXTURE_PORT=${port}
ENV URL_FIXTURE_WORKING_DIR=${workingDir}
ENV URL_FIXTURE_REPO_DIR=${repositoryDir}

ENTRYPOINT exec java -classpath "/fixture/shared/*" \
    fixture.url.URLFixture "$URL_FIXTURE_PORT" "$URL_FIXTURE_WORKING_DIR" "$URL_FIXTURE_REPO_DIR"

EXPOSE $port
