FROM armhf/alpine:latest
RUN apk add --no-cache --update nodejs
COPY package.json package.json
RUN npm i && npm cache clean --force;

COPY app.js app.js
EXPOSE 3000
CMD ["npm", "start"]
