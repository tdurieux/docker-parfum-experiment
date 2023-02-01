FROM golang:1.9.0

RUN go version

RUN apt-get update
RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash
RUN apt-get install --no-install-recommends -y build-essential nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y sqlite3 libsqlite3-dev && rm -rf /var/lib/apt/lists/*;
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
RUN wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add -
RUN apt-get install --no-install-recommends -y postgresql postgresql-contrib libpq-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q mysql-client && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN go get -u github.com/golang/dep/cmd/dep
RUN npm install -g --no-progress yarn && npm cache clean --force;
RUN yarn config set yarn-offline-mirror /npm-packages-offline-cache && yarn cache clean;
RUN yarn config set yarn-offline-mirror-pruning true && yarn cache clean;

ENV BP=$GOPATH/src/github.com/gobuffalo/buffalo

RUN mkdir -p $BP
WORKDIR $BP
ADD . .

RUN go get -v -t ./...

# cache yarn packages to an offline mirror so they're faster to load. hopefully.
RUN grep -v '{{' ./generators/assets/webpack/templates/package.json.tmpl > package.json
RUN yarn install --no-progress && yarn cache clean;

RUN buffalo version

WORKDIR $GOPATH/src

RUN ls -la /npm-packages-offline-cache

EXPOSE 3000