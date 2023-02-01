FROM cypress/browsers:node14.17.0-chrome91-ff89

# Install OpenJDK-11
RUN apt-get update && \
    apt-get install --no-install-recommends -y openjdk-11-jdk && \
    apt-get install --no-install-recommends -y ant && \
    apt-get clean; rm -rf /var/lib/apt/lists/*;

COPY ./package.json /app/package.json

WORKDIR /app

RUN yarn install && yarn cache clean;

ENTRYPOINT [ "./e2e.sh" ]
