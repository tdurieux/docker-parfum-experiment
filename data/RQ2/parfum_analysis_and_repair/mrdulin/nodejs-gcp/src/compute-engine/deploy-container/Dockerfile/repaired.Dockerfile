FROM node:8.9-alpine

ENV PORT=8080

WORKDIR /app
COPY ./package.json ./package-lock.json /app/
COPY ./src/ /app/src
RUN apk update \
  && apk add --no-cache curl \
  && npm i -g npm@latest \
  && npm i --production && npm cache clean --force;

RUN echo "PORT: ${PORT}"
RUN echo "PORT: $PORT"

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:$PORT || exit 1

EXPOSE $PORT
CMD [ "npm", "start" ]