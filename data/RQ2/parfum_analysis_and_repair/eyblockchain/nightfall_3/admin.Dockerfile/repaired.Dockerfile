FROM mongo:focal
# install node
RUN apt-get update

# TEMPORARY WORKAROUND FOR ISSUE https://github.com/nodesource/distributions/issues/1266
RUN apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install --no-install-recommends -y nodejs gcc g++ make && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
COPY common-files common-files
COPY cli cli
WORKDIR /app/common-files
RUN npm ci
WORKDIR /app/cli
RUN npm ci

WORKDIR /app/admin
RUN mkdir /app/admin/mongodb
COPY config/default.js config/default.js
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y netcat-openbsd && rm -rf /var/lib/apt/lists/*;
COPY nightfall-administrator/src src
COPY nightfall-administrator/docker-entrypoint.sh nightfall-administrator/package*.json nightfall-administrator/admin ./

# websocket port 8080
# EXPOSE 8080

RUN npm ci
ENTRYPOINT ["/app/admin/docker-entrypoint.sh"]

CMD ["sleep", "infinity"]
