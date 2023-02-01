FROM ubuntu

WORKDIR /workspace

# Install EnvKey CLI
RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

RUN LATEST_VERSION=$( curl -f https://envkey-releases.s3.amazonaws.com/latest/cli-version.txt) && curl -f -s https://envkey-releases.s3.amazonaws.com/cli/release_artifacts/$LATEST_VERSION/install.sh | bash

# Start app with latest environment
CMD  envkey set another-app development DOCKER_CLI_VAR=$VAL && envkey set db-connection-checker development DOCKER_CLI_VAR=$VAL && envkey commit