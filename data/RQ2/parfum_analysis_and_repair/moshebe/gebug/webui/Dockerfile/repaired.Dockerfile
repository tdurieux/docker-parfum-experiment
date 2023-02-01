FROM golang:1.17
RUN apt-get update
RUN apt-get install --no-install-recommends -y git python jq curl && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_13.x | bash -
RUN apt-get update && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install gulp -g && npm cache clean --force;
RUN npm install yarn -g && npm cache clean --force;

WORKDIR $GOPATH/src/github.com/moshebe/gebug
ENV VUE_APP_PORT 3030
COPY go.mod go.sum ./
COPY ./pkg ./pkg
RUN go mod download

COPY ./webui ./webui
WORKDIR $GOPATH/src/github.com/moshebe/gebug/webui/frontend
RUN yarn install && yarn cache clean;
RUN yarn build && cp -r src/assets dist && yarn cache clean;

WORKDIR $GOPATH/src/github.com/moshebe/gebug/webui
RUN cd frontend && cp -r src/assets dist
ENTRYPOINT go run server.go