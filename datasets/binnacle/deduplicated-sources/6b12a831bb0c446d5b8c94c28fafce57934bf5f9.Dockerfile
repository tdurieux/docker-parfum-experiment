# Generated automatically by update.sh
# Do no edit this file

FROM bigtruedata/scala:2.10.4-alpine

# Install build dependencies
RUN apk add --no-cache --virtual=.dependencies tar wget

Run wget -O- "https://github.com/sbt/sbt/releases/download/v1.0.2/sbt-1.0.2.tgz" \
    |  tar xzf - -C /usr/local --strip-components=1 \
    && sbt exit

# Remove build dependencies
RUN apk del --no-cache .dependencies

VOLUME /app
WORKDIR /app

CMD ["sbt"]
