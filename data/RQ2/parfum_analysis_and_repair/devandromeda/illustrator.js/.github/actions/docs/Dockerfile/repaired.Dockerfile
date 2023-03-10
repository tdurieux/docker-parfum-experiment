FROM node:18-slim

LABEL com.github.actions.name="Documentation Generator"
LABEL com.github.actions.description="Commit generated documentation to the docs branch."
LABEL com.github.actions.icon="upload-cloud"
LABEL com.github.actions.color="red"

RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

COPY src /actions/docs/src
ENTRYPOINT ["/actions/docs/src/entrypoint.sh"]