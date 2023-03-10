FROM node:8

WORKDIR /app
COPY . ./

RUN npm install --silent && npm cache clean --force;

EXPOSE 3000

CMD ["npm", "start"]