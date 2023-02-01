FROM node:14-alpine
# Without git installing the npm packages fails
RUN apk add --no-cache git
RUN mkdir /app
WORKDIR /app
COPY . /app
RUN npm install && npm cache clean --force;
RUN npm run build
ENTRYPOINT ["npm", "run", "prod-start"]
