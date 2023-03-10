FROM node:12.16.1

ARG SPARQL_ENDPOINT_URL
ARG TWITTER_TOKEN
ENV SPARQL_ENDPOINT_URL=${SPARQL_ENDPOINT_URL}
ENV TWITTER_TOKEN=${TWITTER_TOKEN}

RUN mkdir -p /app
COPY . /app
WORKDIR /app

RUN npm i && npm cache clean --force;
RUN npm run build

ENV NODE_ENV=production
ENV HOST 0.0.0.0
ENV PORT 8080

CMD ["npm", "start"]
