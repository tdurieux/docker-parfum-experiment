FROM node:10
WORKDIR /app
COPY . /app
RUN npm install && npm cache clean --force;
RUN npm run build
CMD [ "npm", "start" ]

