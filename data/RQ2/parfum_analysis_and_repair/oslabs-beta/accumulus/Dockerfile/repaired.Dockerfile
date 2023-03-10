FROM node:16.13
WORKDIR /usr/src/app
COPY . /usr/src/app
RUN npm install -g typescript && npm cache clean --force;
RUN npm install && npm cache clean --force;
RUN npm run compile-prod
RUN npm run build-dev
EXPOSE 3000
CMD ["npm", "run", "accumulus"]
# "accumulus": "NODE_ENV=production node --es-module-specifier-resolution=node ./dist/server/server.js"
