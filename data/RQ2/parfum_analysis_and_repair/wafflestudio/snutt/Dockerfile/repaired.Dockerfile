FROM node:8.15-alpine
WORKDIR /app
RUN apk add --no-cache g++ make python
COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .
RUN npm run-script build
CMD ["npm", "start"]

EXPOSE 3000
