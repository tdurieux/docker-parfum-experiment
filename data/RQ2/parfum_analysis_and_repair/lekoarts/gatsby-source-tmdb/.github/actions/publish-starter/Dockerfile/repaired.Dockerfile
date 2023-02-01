FROM node:14-slim

LABEL com.github.actions.name="Publish starter"
LABEL com.github.actions.description="Automatically push subdirectories in a monorepo to their own repositories"
LABEL com.github.actions.icon="package"
LABEL com.github.actions.color="purple"

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y git && \
    apt-get install --no-install-recommends -y jq && rm -rf /var/lib/apt/lists/*;

COPY "entrypoint.sh" "/entrypoint.sh"
RUN chmod +x entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]