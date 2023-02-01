FROM alpine

WORKDIR /app
COPY package.json package-lock.json dist ./
COPY ui-dist /app/ui-dist
RUN apk add --no-cache --update nodejs npm; npm i --ignore-script --only=prod && npm cache clean --force;

EXPOSE 4455 8099 5958
CMD ["node", "index.js"]
