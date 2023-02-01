FROM ubuntu:focal
RUN apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -qq install -y nodejs npm > /dev/null && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /app/public /app/server
COPY src/package.json* /app
WORKDIR /app
RUN npm -s install
COPY src/.babelrc \
     src/.env \
     src/.nodemonrc.json \
     /app/
COPY src/public/ /app/public/
COPY src/server/ /app/server/
EXPOSE 3000
ENTRYPOINT DEBUG='shipit-clicker:*' npm run dev
