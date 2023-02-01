FROM node:12-alpine
RUN apk add --no-cache python g++ make
WORKDIR /scraper
COPY . .
RUN npm install --production && npm cache clean --force;
CMD ["npm", "run-script", "run"]