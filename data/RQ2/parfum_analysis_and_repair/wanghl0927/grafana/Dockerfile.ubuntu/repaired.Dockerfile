FROM golang:1.13.4 AS go-builder

WORKDIR /src/grafana

COPY go.mod go.sum ./
COPY vendor vendor/

RUN go mod verify

COPY build.go package.json ./
COPY pkg pkg/

RUN go run build.go build

FROM node:12.13 AS js-builder

# PhantomJS
RUN apt-get update && apt-get install --no-install-recommends -y curl && \
    curl -f -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 | tar xj && \
    cp phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/app/

COPY package.json yarn.lock ./
COPY packages packages

RUN yarn install --pure-lockfile && yarn cache clean;

COPY Gruntfile.js tsconfig.json .eslintrc .editorconfig .browserslistrc ./
COPY public public
COPY scripts scripts
COPY emails emails

ENV NODE_ENV production
RUN ./node_modules/.bin/grunt build

FROM ubuntu:19.10

LABEL maintainer="Grafana team <hello@grafana.com>"
EXPOSE 3000

ARG GF_UID="472"
ARG GF_GID="472"

ENV PATH="/usr/share/grafana/bin:$PATH" \
    GF_PATHS_CONFIG="/etc/grafana/grafana.ini" \
    GF_PATHS_DATA="/var/lib/grafana" \
    GF_PATHS_HOME="/usr/share/grafana" \
    GF_PATHS_LOGS="/var/log/grafana" \
    GF_PATHS_PLUGINS="/var/lib/grafana/plugins" \
    GF_PATHS_PROVISIONING="/etc/grafana/provisioning"

WORKDIR $GF_PATHS_HOME

COPY conf conf

# We need font libs for phantomjs, and curl should be part of the image
RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y ca-certificates libfontconfig1 curl && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p "$GF_PATHS_HOME/.aws" && \
  addgroup --system --gid $GF_GID grafana && \
  adduser --uid $GF_UID --system --ingroup grafana grafana && \
  mkdir -p "$GF_PATHS_PROVISIONING/datasources" \
             "$GF_PATHS_PROVISIONING/dashboards" \
             "$GF_PATHS_PROVISIONING/notifiers" \
             "$GF_PATHS_LOGS" \
             "$GF_PATHS_PLUGINS" \
             "$GF_PATHS_DATA" && \
    cp conf/sample.ini "$GF_PATHS_CONFIG" && \
    cp conf/ldap.toml /etc/grafana/ldap.toml && \
    chown -R grafana:grafana "$GF_PATHS_DATA" "$GF_PATHS_HOME/.aws" "$GF_PATHS_LOGS" "$GF_PATHS_PLUGINS" "$GF_PATHS_PROVISIONING" && \
    chmod -R 777 "$GF_PATHS_DATA" "$GF_PATHS_HOME/.aws" "$GF_PATHS_LOGS" "$GF_PATHS_PLUGINS" "$GF_PATHS_PROVISIONING"

# PhantomJS
COPY --from=js-builder /usr/local/bin/phantomjs /usr/local/bin/

COPY --from=go-builder /src/grafana/bin/linux-amd64/grafana-server /src/grafana/bin/linux-amd64/grafana-cli bin/
COPY --from=js-builder /usr/src/app/public public
COPY --from=js-builder /usr/src/app/tools tools

COPY tools/phantomjs/render.js tools/phantomjs/
COPY packaging/docker/run.sh /

USER grafana
ENTRYPOINT [ "/run.sh" ]
