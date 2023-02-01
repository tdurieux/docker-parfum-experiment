FROM alpine

WORKDIR /app
COPY . .
RUN apk add --no-cache --update nodejs npm; cd UI; npm i --ignore-scripts; npm cache clean --force; npm run build; cd ..; npm i --ignore-scripts; npm run build

EXPOSE 4455 8099 5958
CMD ["node", "dist/index.js"]
