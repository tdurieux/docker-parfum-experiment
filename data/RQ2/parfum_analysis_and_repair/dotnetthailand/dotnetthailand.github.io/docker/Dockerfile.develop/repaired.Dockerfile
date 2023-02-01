FROM node:buster-slim as builder

WORKDIR /app

RUN apt-get update \
    && apt-get install --no-install-recommends -y git net-tools \
    && npm install -g gatsby-cli && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

COPY package*.json ./

RUN yarn

COPY . .
RUN mv scripts/* /usr/local/bin \
    && rm -rf scripts \
    && chmod +x /usr/local/bin/* \
    && rm -rf content/*

EXPOSE 8000

CMD ["run_local.sh"]
