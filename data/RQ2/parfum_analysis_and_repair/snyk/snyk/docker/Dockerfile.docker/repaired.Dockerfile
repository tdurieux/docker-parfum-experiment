FROM node:14-slim

MAINTAINER Snyk Ltd

# Install Docker
RUN apt-get update && \
    apt-get install --no-install-recommends -y apt-transport-https ca-certificates curl gnupg2 software-properties-common git && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
    apt-get update && apt-get install --no-install-recommends -y docker-ce && \
    npm install --global snyk snyk-to-html && \
    apt-get autoremove -y && \
    apt-get clean && \
    chmod -R a+wrx /home/node && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

WORKDIR /home/node
ENV HOME /home/node

# The path at which the project is mounted (-v runtime arg)
ENV PROJECT_PATH /project

COPY docker-entrypoint.sh .

ENV SNYK_INTEGRATION_NAME DOCKER_SNYK_CLI
ENV SNYK_INTEGRATION_VERSION docker

ENTRYPOINT ["./docker-entrypoint.sh"]

# Default command is `snyk test`
# Override with `docker run ... snyk/snyk-cli <command> <args>`
CMD ["test"]
