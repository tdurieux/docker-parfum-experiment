FROM node:6.3.0

WORKDIR /usr/src/react-server/

ENV NODE_ENV=development

# NPM install package.json file
COPY package.json package.json
RUN npm install && npm cache clean --force;

# Bootstrap everything else
COPY . .
RUN npm run bootstrap
