FROM node:10.22.0

WORKDIR /app
COPY . /app/

RUN npm install && npm cache clean --force;
RUN npm run build-production

EXPOSE 4004
CMD [ "npm", "start" ]
