FROM node:alpine
RUN apk add git g++ make python3
WORKDIR /app
COPY ["package.json", "package-lock.json*", "./"]
RUN npm install
CMD npx docusaurus build && npm run serve
