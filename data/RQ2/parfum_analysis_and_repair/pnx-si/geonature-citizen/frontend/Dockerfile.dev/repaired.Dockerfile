FROM node:14

WORKDIR /app
RUN npm install -g webpack webpack-cli html-webpack-plugin webpack-dev-server webpack-dev-middleware && npm cache clean --force;
CMD npm install; npm run start
