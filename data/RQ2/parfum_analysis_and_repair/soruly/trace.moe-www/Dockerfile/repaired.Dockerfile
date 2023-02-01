FROM node:lts-alpine
RUN apk add --no-cache tini
ENTRYPOINT ["/sbin/tini", "--"]
ENV NODE_ENV=production
WORKDIR /app
COPY . .
RUN npm install --production && npm cache clean --force;
CMD [ "npm", "run", "build-export-start" ]
