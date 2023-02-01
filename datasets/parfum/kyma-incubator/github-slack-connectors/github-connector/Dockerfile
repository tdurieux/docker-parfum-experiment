FROM golang:1.11.4-alpine3.8 as builder

WORKDIR /go/src/github.com/kyma-incubator/github-slack-connectors/github-connector

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o main ./cmd/github-connector
RUN mkdir /app && mv ./main /app/main && mv ./internal/registration/configs/githubasyncapi.json /app/githubasyncapi.json

FROM alpine:3.8
WORKDIR /app

RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*

COPY --from=builder /app/main /app
COPY --from=builder /app/githubasyncapi.json /app

CMD ["./main"]