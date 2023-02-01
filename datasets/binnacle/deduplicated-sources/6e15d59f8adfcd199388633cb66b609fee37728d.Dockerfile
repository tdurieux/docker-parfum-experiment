# build stage
FROM golang:1.10.2-alpine3.7 AS build-env
RUN apk --no-cache add git
RUN go get p83.nl/go/ekster/...

# final stage
FROM alpine
RUN apk --no-cache add ca-certificates
RUN ["mkdir", "-p", "/opt/micropub"]
WORKDIR /opt/micropub
EXPOSE 80
COPY --from=build-env /go/bin/eksterd /app/
RUN ["mkdir", "/app/templates"]
COPY --from=build-env /go/src/p83.nl/go/ekster/templates /app/templates
ENTRYPOINT ["/app/eksterd"]
