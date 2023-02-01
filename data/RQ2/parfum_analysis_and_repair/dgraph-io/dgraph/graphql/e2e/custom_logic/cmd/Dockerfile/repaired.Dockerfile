FROM golang:1.14.2-alpine3.11

COPY . .

RUN apk update && apk add --no-cache git && apk add --no-cache nodejs && apk add --no-cache npm

RUN go get gopkg.in/yaml.v2

RUN go get github.com/graph-gophers/graphql-go/...

RUN npm install && npm cache clean --force;

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main main.go

WORKDIR .

CMD ./main