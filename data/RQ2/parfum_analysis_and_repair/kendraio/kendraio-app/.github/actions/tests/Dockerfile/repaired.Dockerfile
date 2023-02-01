FROM cypress/included:8.4.1

# https://docs.cypress.io/guides/continuous-integration/introduction#Machine-requirements
RUN apt-get update && apt-get install --no-install-recommends -y curl jq && rm -rf /var/lib/apt/lists/*;
# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
