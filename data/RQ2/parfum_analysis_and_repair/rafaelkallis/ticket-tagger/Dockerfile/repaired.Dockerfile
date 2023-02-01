FROM node:12

WORKDIR app
COPY ./ ./

RUN npm install --production && npm cache clean --force;

CMD ["npm", "start"]
