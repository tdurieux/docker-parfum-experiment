FROM mongo:4.4.1-bionic

# install node
RUN apt-get update

# TEMPORARY WORKAROUND FOR ISSUE https://github.com/nodesource/distributions/issues/1266
RUN apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;

WORKDIR /
COPY common-files common-files
COPY config/default.js app/config/default.js

WORKDIR /app
RUN mkdir /app/mongodb

COPY nightfall-client/src src
COPY nightfall-client/docker-entrypoint.sh nightfall-client/pre-start-script.sh nightfall-client/package.json nightfall-client/package-lock.json ./

RUN npm ci

EXPOSE 27017
EXPOSE 80

ENTRYPOINT ["/app/docker-entrypoint.sh"]

CMD ["npm", "start"]
