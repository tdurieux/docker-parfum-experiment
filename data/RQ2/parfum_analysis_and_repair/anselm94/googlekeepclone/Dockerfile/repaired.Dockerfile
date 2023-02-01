# Build Go module
FROM golang:1.16 AS gobuilder
WORKDIR /app
COPY ./server ./server
COPY ./cmd ./cmd
COPY config.go .
COPY go.mod .
COPY go.sum .
RUN go mod download
RUN go build -o bin/server ./cmd/server

# Build Web resources
FROM node:14.16.1 AS webbuilder
WORKDIR /web
COPY /web .
ENV REACT_APP_WEBSOCKET_ENDPOINT="wss://googlekeep-anselm94.herokuapp.com/query"
RUN npm install && npm cache clean --force;
RUN npm run build

# Build final image
# Need to use Golang image, as SQLite requires CGO,
# and cannot be created a standalone executable
FROM golang:1.16
WORKDIR /
COPY --from=gobuilder /app/bin/ ./
COPY --from=webbuilder /web/build ./static
COPY run.sh .
RUN apt-get update && apt-get install --no-install-recommends -y uuid-runtime && rm -rf /var/lib/apt/lists/*;
ENV HOST=https://googlekeep-anselm94.herokuapp.com
EXPOSE 80
CMD ["sh", "run.sh"]