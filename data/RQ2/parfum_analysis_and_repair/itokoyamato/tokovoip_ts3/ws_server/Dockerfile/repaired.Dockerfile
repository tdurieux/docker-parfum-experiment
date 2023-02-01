FROM node:14.4.0-alpine

WORKDIR /app
COPY . .

RUN npm install --production && npm cache clean --force;

EXPOSE 33250

CMD ["npm", "start"]
