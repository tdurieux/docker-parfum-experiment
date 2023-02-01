FROM cypress/base:16.14.2

RUN apt-get update && apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;

RUN adduser --disabled-password jahians
USER jahians

COPY --chown=jahians:jahians ./package.json ./yarn.lock /tmp/
WORKDIR /tmp

#CI=true reduces the verbosity of the installation logs
RUN CI=true yarn install && yarn cache clean;
RUN CI=true /tmp/node_modules/.bin/cypress install

COPY --chown=jahians:jahians . /tmp/

RUN mkdir /tmp/run-artifacts
RUN mkdir -p /tmp/results

CMD ["/bin/bash", "-c", "/tmp/env.run.sh"]
