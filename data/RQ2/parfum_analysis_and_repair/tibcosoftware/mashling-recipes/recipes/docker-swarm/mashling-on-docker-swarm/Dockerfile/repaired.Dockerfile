FROM alpine
LABEL maintainer "."
RUN apk update && apk add --no-cache ca-certificates
ADD mashling.json .
ADD mashling-gateway .
CMD ./mashling-gateway -c mashling.json
