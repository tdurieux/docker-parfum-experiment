FROM node:alpine
RUN apk add --no-cache git g++ make python3
WORKDIR /app
COPY ["package.json", "package-lock.json*", "./"]
RUN npm install && npm cache clean --force;
CMD npx docusaurus build && npm run serve
