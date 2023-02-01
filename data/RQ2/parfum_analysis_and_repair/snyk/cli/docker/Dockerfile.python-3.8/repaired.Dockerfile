FROM python:3.8-slim

MAINTAINER Snyk Ltd

RUN mkdir /home/node
WORKDIR /home/node

# Install Python utilities, node, Snyk CLI
RUN pip install --no-cache-dir pip pipenv==2021.5.29 virtualenv -U && \
    apt-get update && \
    apt-get install --no-install-recommends -y build-essential curl git && \
    curl -f -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    npm install --global snyk snyk-to-html && \
    apt-get autoremove -y && \
    apt-get clean && \
    chmod -R a+wrx /home/node && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

ENV HOME /home/node

# The path at which the project is mounted (-v runtime arg)
ENV PROJECT_PATH /project

COPY docker-python-entrypoint.sh .
COPY docker-entrypoint.sh .

ENV SNYK_INTEGRATION_NAME DOCKER_SNYK_CLI
ENV SNYK_INTEGRATION_VERSION python-3.8

ENTRYPOINT ["./docker-python-entrypoint.sh"]

# Default command is `snyk test`
# Override with `docker run ... snyk/snyk-cli <command> <args>`
CMD ["test"]
