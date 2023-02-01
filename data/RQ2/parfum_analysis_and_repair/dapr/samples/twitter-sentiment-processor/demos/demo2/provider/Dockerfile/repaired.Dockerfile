FROM node:10

WORKDIR /app/
COPY . /app/

RUN npm install --only=production && npm cache clean --force;

EXPOSE 3001

CMD [ "node", "app.js" ]