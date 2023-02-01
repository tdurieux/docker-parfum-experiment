# Builder
FROM registry.digitalservice.id/proxyjds/library/golang:1.14.2-alpine3.11 as builder

RUN apk update && apk upgrade && \
    apk --update --no-cache add git make

WORKDIR /app

COPY . .

RUN make worker

# Distribution
FROM registry.digitalservice.id/proxyjds/library/alpine:latest

ENV TZ=Asia/Jakarta
RUN apk update && apk upgrade && \
    apk --update --no-cache add tzdata && \
    cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    mkdir /app

WORKDIR /app

COPY --from=builder /app/src/worker /app

CMD /app/worker
