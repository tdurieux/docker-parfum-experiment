FROM node:6

WORKDIR /app
ADD . /app

RUN npm install && npm cache clean --force;

EXPOSE 3000

CMD ["npm", "run", "serve"]
