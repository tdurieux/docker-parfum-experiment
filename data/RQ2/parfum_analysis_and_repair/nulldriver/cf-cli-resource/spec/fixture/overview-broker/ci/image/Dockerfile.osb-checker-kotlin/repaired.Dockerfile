FROM zenika/kotlin:1.3-jdk12-alpine
LABEL maintainer "Matt McNeeney <matt@mattmc.co.uk>"

RUN apk update && apk add --no-cache nodejs npm yarn
